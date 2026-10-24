import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course.dart';

/// Per-course progress snapshot (held in memory).
class CourseProgress {
  int xp;
  int streak;
  String? lastDay;
  final Set<String> completed;
  CourseProgress({
    this.xp = 0,
    this.streak = 0,
    this.lastDay,
    Set<String>? completed,
  }) : completed = completed ?? <String>{};
}

/// Owns the learner's enrolled courses and their per-course progress, persisted
/// locally. Dailo is a multi-course platform: XP, level, and streak are tracked
/// separately for each course the learner has added.
class ProgressStore extends ChangeNotifier {
  static const _kEnrolled = 'dailo.enrolledCourses';
  // Per-course keys are built as 'dailo.<courseId>.<field>'.

  static const int baseXpPerLesson = 10;
  static const int perfectBonus = 5;

  SharedPreferences? _prefs;

  final List<String> _enrolled = []; // course ids, in add order
  final Map<String, CourseProgress> _byCourse = {};

  List<String> get enrolledCourseIds => List.unmodifiable(_enrolled);
  bool get hasAnyCourse => _enrolled.isNotEmpty;
  bool isEnrolled(String courseId) => _enrolled.contains(courseId);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _enrolled
      ..clear()
      ..addAll(_prefs!.getStringList(_kEnrolled) ?? const []);
    for (final id in _enrolled) {
      _byCourse[id] = _loadCourse(id);
    }
    notifyListeners();
  }

  CourseProgress _loadCourse(String courseId) {
    final p = _prefs!;
    final cp = CourseProgress(
      xp: p.getInt('dailo.$courseId.xp') ?? 0,
      streak: p.getInt('dailo.$courseId.streak') ?? 0,
      lastDay: p.getString('dailo.$courseId.lastDay'),
      completed: (p.getStringList('dailo.$courseId.completed') ?? const [])
          .toSet(),
    );
    _refreshStreakForToday(cp);
    return cp;
  }

  CourseProgress _progress(String courseId) =>
      _byCourse.putIfAbsent(courseId, () => CourseProgress());

  // --- enrollment ---

  Future<void> enroll(String courseId) async {
    if (_enrolled.contains(courseId)) return;
    _enrolled.add(courseId);
    _byCourse[courseId] = CourseProgress();
    await _prefs?.setStringList(_kEnrolled, _enrolled);
    await _saveCourse(courseId);
    notifyListeners();
  }

  // --- per-course reads ---

  int xp(String courseId) => _progress(courseId).xp;
  int streak(String courseId) => _progress(courseId).streak;

  int level(String courseId) {
    var lvl = 1;
    var remaining = xp(courseId);
    while (remaining >= 50 * lvl) {
      remaining -= 50 * lvl;
      lvl++;
    }
    return lvl;
  }

  (int earned, int needed) levelProgress(String courseId) {
    var lvl = 1;
    var remaining = xp(courseId);
    while (remaining >= 50 * lvl) {
      remaining -= 50 * lvl;
      lvl++;
    }
    return (remaining, 50 * lvl);
  }

  int completedCount(String courseId) => _progress(courseId).completed.length;

  bool isLessonComplete(String courseId, String lessonId) =>
      _progress(courseId).completed.contains(lessonId);

  bool isLessonUnlocked(String courseId, Unit unit, int index) {
    if (index <= 0) return true;
    return _progress(courseId).completed.contains(unit.lessons[index - 1].id);
  }

  bool isUnitComplete(String courseId, Unit unit) =>
      unit.lessons.every((l) => _progress(courseId).completed.contains(l.id));

  bool isUnitUnlocked(String courseId, Course course, Unit unit) {
    if (unit.prerequisites.isEmpty) return true;
    for (final preId in unit.prerequisites) {
      final pre = course.units.where((u) => u.id == preId);
      if (pre.isEmpty) continue;
      if (!isUnitComplete(courseId, pre.first)) return false;
    }
    return true;
  }

  // --- per-course writes ---

  Future<int> completeLesson(
    String courseId,
    String lessonId, {
    required bool perfect,
  }) async {
    final cp = _progress(courseId);
    final firstTime = !cp.completed.contains(lessonId);
    var awarded = 0;
    if (firstTime) {
      cp.completed.add(lessonId);
      awarded = baseXpPerLesson + (perfect ? perfectBonus : 0);
      cp.xp += awarded;
    }
    _bumpStreak(cp);
    await _saveCourse(courseId);
    notifyListeners();
    return awarded;
  }

  // --- streak logic (per course) ---

  String _today() => _dayOffset(0);

  String _dayOffset(int days) {
    final n = DateTime.now().add(Duration(days: days));
    return '${n.year.toString().padLeft(4, '0')}-'
        '${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  void _bumpStreak(CourseProgress cp) {
    final today = _today();
    if (cp.lastDay == today) return;
    if (cp.lastDay == _dayOffset(-1)) {
      cp.streak += 1;
    } else {
      cp.streak = 1;
    }
    cp.lastDay = today;
  }

  void _refreshStreakForToday(CourseProgress cp) {
    if (cp.lastDay == null) {
      cp.streak = 0;
      return;
    }
    final today = _today();
    final yesterday = _dayOffset(-1);
    if (cp.lastDay != today && cp.lastDay != yesterday) {
      cp.streak = 0;
    }
  }

  Future<void> _saveCourse(String courseId) async {
    final p = _prefs;
    if (p == null) return;
    final cp = _progress(courseId);
    await p.setInt('dailo.$courseId.xp', cp.xp);
    await p.setInt('dailo.$courseId.streak', cp.streak);
    if (cp.lastDay != null) {
      await p.setString('dailo.$courseId.lastDay', cp.lastDay!);
    }
    await p.setStringList('dailo.$courseId.completed', cp.completed.toList());
  }

  /// Total XP across all enrolled courses (for a platform-level flourish).
  int get totalXp =>
      _enrolled.fold(0, (sum, id) => sum + (_byCourse[id]?.xp ?? 0));
}
