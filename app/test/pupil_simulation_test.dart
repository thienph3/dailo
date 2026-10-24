// Pupil simulation — DATA & LOGIC layer.
//
// Simulates a pupil going through the WHOLE course the way the app does, but at
// the content+logic layer (fast, 100% coverage): it loads every lesson via the
// real ContentLoader, parses it with the real models, and for each exercise it
// synthesizes the correct answer (and, ~1% of the time, a wrong one) and feeds
// it through the real ExerciseChecker — exactly what the lesson player does.
//
// This catches hidden bugs that only surface across all 10,000 questions:
//   • JSON that fails to parse / missing fields
//   • answers that don't actually validate as correct (authoring/engine drift)
//   • checker crashes on an exercise shape
//   • wrong answers that wrongly validate as correct
//
// Everything (progress + any exception with full context) is written to
// build/pupil_sim_log.txt so it can run in the background and be inspected after.
//
// Run headless:  flutter test integration_test/pupil_simulation_test.dart

import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dailo/content/catalog.dart';
import 'package:dailo/content/content_loader.dart';
import 'package:dailo/data/progress_store.dart';
import 'package:dailo/features/lesson/exercise_widgets.dart';
import 'package:dailo/models/course.dart';

/// ~1% wrong-answer ratio, deterministic via a seeded RNG for reproducibility.
const double kWrongRatio = 0.01;
final Random _rng = Random(42);

void main() {
  // Needed so rootBundle can read assets from the test binary.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pupil walks the entire course, ~1% wrong answers', () async {
    final log = _Logger('build/pupil_sim_log.txt');
    await log.start();

    var unitsSeen = 0,
        lessonsSeen = 0,
        exercises = 0,
        correctChecks = 0,
        wrongChecks = 0;
    final problems = <String>[];

    try {
      // 1) Catalog loads and has at least one course (the forced first course).
      final catalog = CatalogLoader();
      final entries = await catalog.load();
      if (entries.isEmpty) {
        problems.add('CATALOG: no courses available to add');
      }
      await log.line('Catalog loaded: ${entries.length} course(s)');

      // 2) The pupil "adds" and opens the first course.
      final entry = entries.first;
      final loader = ContentLoader(
        coursePath: entry.coursePath,
        contentBase: entry.contentBase,
      );
      final course = await loader.loadCourse();
      await log.line('Opened course "${course.title}" with '
          '${course.units.length} units, ${course.laps.length} laps');

      // 3) Walk units -> lessons -> exercises IN ORDER (as the app forces).
      for (final unit in course.units) {
        unitsSeen++;
        for (var li = 0; li < unit.lessons.length; li++) {
          final ref = unit.lessons[li];
          Lesson lesson;
          try {
            lesson = await loader.loadLesson(ref);
          } catch (e, st) {
            problems.add('LOAD FAIL ${unit.id}/${ref.id} (${ref.file}): $e');
            await log.error('load ${ref.file}', e, st);
            continue;
          }
          lessonsSeen++;

          if (lesson.exercises.length != 10) {
            problems.add(
                'SHAPE ${lesson.id}: ${lesson.exercises.length} exercises (want 10)');
          }

          for (final ex in lesson.exercises) {
            exercises++;
            final where = '${unit.id}/${lesson.id}/${ex.id} [${ex.type.name}]';

            // Synthesize the CORRECT answer and assert the checker accepts it.
            try {
              final correct = _correctAnswer(ex);
              final ok = ExerciseChecker.isCorrect(ex, correct);
              if (!ok) {
                problems.add('CORRECT-REJECTED $where :: '
                    'synthesized=${_short(correct)} answerField=${_short(ex.answer)}');
              } else {
                correctChecks++;
              }
            } catch (e, st) {
              problems.add('CHECKER-THREW(correct) $where: $e');
              await log.error('checker(correct) $where', e, st);
            }

            // ~1% of the time, also feed a WRONG answer and assert rejection.
            if (_rng.nextDouble() < kWrongRatio) {
              try {
                final wrong = _wrongAnswer(ex);
                if (wrong != null) {
                  final rejected = !ExerciseChecker.isCorrect(ex, wrong);
                  if (!rejected) {
                    problems.add('WRONG-ACCEPTED $where :: wrong=${_short(wrong)}');
                  } else {
                    wrongChecks++;
                  }
                }
              } catch (e, st) {
                problems.add('CHECKER-THREW(wrong) $where: $e');
                await log.error('checker(wrong) $where', e, st);
              }
            }
          }
        }
        if (unit.id == 'u05' || unit.id == 'u50' || unit.id == 'u100') {
          await log.line('…reached ${unit.id} '
              '($lessonsSeen lessons, $exercises exercises so far)');
        }
      }
    } catch (e, st) {
      problems.add('FATAL: $e');
      await log.error('fatal', e, st);
    }

    await log.line('');
    await log.line('==== SUMMARY ====');
    await log.line('units: $unitsSeen  lessons: $lessonsSeen  exercises: $exercises');
    await log.line('correct-answer checks passed: $correctChecks');
    await log.line('wrong-answer checks passed:   $wrongChecks');
    await log.line('problems found: ${problems.length}');
    for (final p in problems.take(200)) {
      await log.line('  • $p');
    }
    await log.finish();

    // The test fails if any problem was found, surfacing hidden bugs.
    expect(problems, isEmpty,
        reason: 'See build/pupil_sim_log.txt — ${problems.length} problem(s). '
            'First few: ${problems.take(5).join(" | ")}');
  }, timeout: const Timeout(Duration(minutes: 10)));

  // Simulates the UNIT TRANSITION the pupil goes through: complete every
  // lesson of a unit in order via the REAL ProgressStore, then assert the next
  // unit unlocks and the course never gets "stuck". This exercises exactly the
  // unlock/progression logic that runs when moving from one unit to the next.
  test('completing each unit in order unlocks the next, all 100 units',
      () async {
    SharedPreferences.setMockInitialValues({});
    final log = _Logger('build/pupil_transition_log.txt');
    await log.start();
    final problems = <String>[];

    final entry = (await CatalogLoader().load()).first;
    final loader = ContentLoader(
      coursePath: entry.coursePath,
      contentBase: entry.contentBase,
    );
    final course = await loader.loadCourse();

    final store = ProgressStore();
    await store.load();
    await store.enroll(course.id);

    // Unit 1 must start unlocked.
    if (!store.isUnitUnlocked(course.id, course, course.units.first)) {
      problems.add('Unit 1 (${course.units.first.id}) is locked at the start');
    }

    for (var ui = 0; ui < course.units.length; ui++) {
      final unit = course.units[ui];

      if (!store.isUnitUnlocked(course.id, course, unit)) {
        problems.add('STUCK: ${unit.id} never unlocked after completing '
            '${ui == 0 ? "nothing" : course.units[ui - 1].id}');
        break; // can't proceed — this is the transition bug
      }

      // Complete each lesson in order; each must be unlocked before the one
      // after it (sequential lesson gating).
      for (var li = 0; li < unit.lessons.length; li++) {
        if (!store.isLessonUnlocked(course.id, unit, li)) {
          problems.add('STUCK: ${unit.id} lesson $li locked out of order');
          break;
        }
        await store.completeLesson(course.id, unit.lessons[li].id,
            perfect: true);
      }

      if (!store.isUnitComplete(course.id, unit)) {
        problems.add('${unit.id} not marked complete after finishing all its '
            'lessons');
      }

      // The transition: the NEXT unit should now be unlocked.
      if (ui + 1 < course.units.length) {
        final next = course.units[ui + 1];
        if (!store.isUnitUnlocked(course.id, course, next)) {
          problems.add('TRANSITION FAIL: ${next.id} still locked after '
              'completing ${unit.id}');
        }
      }

      if (unit.id == 'u01' || unit.id == 'u50' || unit.id == 'u100') {
        await log.line('completed ${unit.id}; '
            'xp=${store.xp(course.id)} level=${store.level(course.id)}');
      }
    }

    // After finishing everything, the final unit is complete and XP accrued.
    final lastDone = store.isUnitComplete(course.id, course.units.last);
    await log.line('');
    await log.line('==== TRANSITION SUMMARY ====');
    await log.line('units completed in order: ${course.units.length}');
    await log.line('final unit complete: $lastDone');
    await log.line('total XP: ${store.xp(course.id)}  '
        'level: ${store.level(course.id)}  streak: ${store.streak(course.id)}');
    await log.line('problems: ${problems.length}');
    for (final p in problems.take(50)) {
      await log.line('  • $p');
    }
    await log.finish();

    expect(problems, isEmpty,
        reason: 'See build/pupil_transition_log.txt — '
            '${problems.length} problem(s): ${problems.take(5).join(" | ")}');
  }, timeout: const Timeout(Duration(minutes: 10)));
}

// --- answer synthesis (inverse of the checker) ---

Object? _correctAnswer(Exercise ex) {
  switch (ex.type) {
    case ExerciseType.multipleChoice:
      return (ex.answer as num).toInt();
    case ExerciseType.trueFalse:
      return ex.answer as bool;
    case ExerciseType.multiSelect:
      return (ex.answer as List).map((e) => (e as num).toInt()).toSet();
    case ExerciseType.fillBlank:
      // Prefer the canonical answer; fall back to first acceptable.
      if (ex.answer is String) return ex.answer as String;
      return ex.acceptable.isNotEmpty ? ex.acceptable.first : '';
    case ExerciseType.orderBlocks:
      return (ex.answer as List).map((e) => (e as num).toInt()).toList();
    case ExerciseType.tapTokens:
      return (ex.answer as List).map((e) => e.toString()).toList();
    case ExerciseType.matchPairs:
      return {for (final p in ex.pairs) p.left: p.right};
  }
}

/// A deliberately wrong answer, or null if the exercise can't be made wrong
/// (e.g. a single-option degenerate case — shouldn't happen in this course).
Object? _wrongAnswer(Exercise ex) {
  switch (ex.type) {
    case ExerciseType.multipleChoice:
      final correct = (ex.answer as num).toInt();
      if (ex.options.length < 2) return null;
      return correct == 0 ? 1 : 0;
    case ExerciseType.trueFalse:
      return !(ex.answer as bool);
    case ExerciseType.multiSelect:
      final want = (ex.answer as List).map((e) => (e as num).toInt()).toSet();
      // Flip one membership to make it wrong.
      final all = List<int>.generate(ex.options.length, (i) => i);
      for (final i in all) {
        final flipped = {...want};
        if (flipped.contains(i)) {
          flipped.remove(i);
        } else {
          flipped.add(i);
        }
        if (!(flipped.length == want.length && flipped.containsAll(want))) {
          return flipped;
        }
      }
      return null;
    case ExerciseType.fillBlank:
      return '___definitely_wrong___';
    case ExerciseType.orderBlocks:
      final want = (ex.answer as List).map((e) => (e as num).toInt()).toList();
      if (want.length < 2) return null;
      final swapped = [...want];
      final t = swapped[0];
      swapped[0] = swapped[1];
      swapped[1] = t;
      // If swapping produced the same sequence (dupes), bail.
      var same = true;
      for (var i = 0; i < want.length; i++) {
        if (swapped[i] != want[i]) {
          same = false;
          break;
        }
      }
      return same ? null : swapped;
    case ExerciseType.tapTokens:
      final want = (ex.answer as List).map((e) => e.toString()).toList();
      if (want.length < 2) return null;
      final swapped = [...want];
      final t = swapped[0];
      swapped[0] = swapped[1];
      swapped[1] = t;
      if (swapped.join('\u0001') == want.join('\u0001')) return null;
      return swapped;
    case ExerciseType.matchPairs:
      if (ex.pairs.length < 2) return null;
      final m = {for (final p in ex.pairs) p.left: p.right};
      // Swap two rights to make at least one pair wrong.
      m[ex.pairs[0].left] = ex.pairs[1].right;
      m[ex.pairs[1].left] = ex.pairs[0].right;
      return m;
  }
}

String _short(Object? v) {
  final s = '$v';
  return s.length > 60 ? '${s.substring(0, 60)}…' : s;
}

// --- file logger ---

class _Logger {
  _Logger(this.path);
  final String path;
  late final IOSink _sink;
  late final File _file;

  Future<void> start() async {
    _file = File(path);
    await _file.parent.create(recursive: true);
    _sink = _file.openWrite();
    final now = DateTime.now().toIso8601String();
    _sink.writeln('===== Dailo pupil simulation — $now =====');
  }

  Future<void> line(String s) async => _sink.writeln(s);

  Future<void> error(String context, Object e, StackTrace st) async {
    _sink.writeln('!! EXCEPTION in $context: $e');
    _sink.writeln(st.toString().split('\n').take(6).join('\n'));
  }

  Future<void> finish() async {
    await _sink.flush();
    await _sink.close();
    // Mirror the log to stdout so `flutter test` output shows it too.
    stdout.writeln(await _file.readAsString());
  }
}
