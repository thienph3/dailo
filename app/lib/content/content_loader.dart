import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

/// Loads one course's content from bundled JSON assets.
///
/// A loader is scoped to a single course: [coursePath] points at that course's
/// course.json, and lesson files are resolved relative to [contentBase].
/// Lessons load on demand so we never hold all exercises in memory at once.
///
/// Tests may preload data via [seedCourse] / [seedLesson] so the whole flow can
/// run under a fake test clock with no real asset I/O.
class ContentLoader {
  ContentLoader({required this.coursePath, required this.contentBase});

  final String coursePath; // e.g. assets/course/course.json
  final String contentBase; // e.g. assets/course/

  Course? _course;
  final Map<String, Lesson> _seededLessons = {}; // by LessonRef.file

  /// Test hook: provide the parsed course up front.
  void seedCourse(Course course) => _course = course;

  /// Test hook: provide a parsed lesson for a given ref file path.
  void seedLesson(String file, Lesson lesson) => _seededLessons[file] = lesson;

  Future<Course> loadCourse() async {
    if (_course != null) return _course!;
    final raw = await rootBundle.loadString(coursePath);
    _course = Course.fromJson(json.decode(raw) as Map<String, dynamic>);
    return _course!;
  }

  /// Load a lesson's exercises. [ref.file] is relative to [contentBase]
  /// (e.g. "content/unit-01/lesson-01.json").
  Future<Lesson> loadLesson(LessonRef ref) async {
    final seeded = _seededLessons[ref.file];
    if (seeded != null) return seeded;
    final raw = await rootBundle.loadString('$contentBase${ref.file}');
    return Lesson.fromJson(json.decode(raw) as Map<String, dynamic>);
  }
}
