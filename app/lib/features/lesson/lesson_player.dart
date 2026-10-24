import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../main.dart';
import '../../models/course.dart';
import 'exercise_widgets.dart';

/// Plays a lesson: one exercise at a time, with instant feedback and a progress
/// bar. On finish, awards XP via the ProgressStore (perfect run = bonus).
class LessonPlayer extends StatefulWidget {
  const LessonPlayer({super.key, required this.courseId, required this.lesson});
  final String courseId;
  final Lesson lesson;

  @override
  State<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends State<LessonPlayer> {
  // A queue of exercise indices still to answer correctly. Starts as 0..n-1.
  // A wrong answer re-adds that exercise to the back, so the lesson only ends
  // once every exercise has been answered correctly (a "fix your mistakes"
  // phase, Duolingo-style).
  late final List<int> _queue;
  int _answeredCorrectly = 0; // distinct exercises cleared (for progress)
  final Set<int> _everWrong = {}; // exercises missed at least once (no bonus)

  bool _checked = false;
  bool _correct = false;
  bool _finished = false;
  int _awardedXp = 0;

  /// We're in the "fix your mistakes" phase when the current exercise is one
  /// that was already answered wrong earlier in this lesson.
  bool get _inFixPhase => _queue.isNotEmpty && _everWrong.contains(_queue.first);

  // The current exercise's answer, owned here and mutated by the child widget.
  final ValueNotifier<Object?> _draft = ValueNotifier<Object?>(null);

  @override
  void initState() {
    super.initState();
    _queue = List<int>.generate(widget.lesson.exercises.length, (i) => i);
  }

  Exercise get _ex => widget.lesson.exercises[_queue.first];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _check() {
    final ok = ExerciseChecker.isCorrect(_ex, _draft.value);
    setState(() {
      _checked = true;
      _correct = ok;
      if (!ok) _everWrong.add(_queue.first);
    });
  }

  Future<void> _next() async {
    final current = _queue.removeAt(0);
    if (_correct) {
      _answeredCorrectly++;
    } else {
      // Put it back at the end to be retried before the lesson can finish.
      _queue.add(current);
    }

    if (_queue.isEmpty) {
      // All exercises answered correctly — award XP once.
      final store = ProgressScope.of(context);
      final xp = await store.completeLesson(
        widget.courseId,
        widget.lesson.id,
        perfect: _everWrong.isEmpty,
      );
      if (!mounted) return;
      setState(() {
        _finished = true;
        _awardedXp = xp;
      });
      return;
    }

    setState(() {
      _checked = false;
      _correct = false;
      _draft.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return _ResultScreen(
        lesson: widget.lesson,
        perfect: _everWrong.isEmpty,
        awardedXp: _awardedXp,
      );
    }

    final total = widget.lesson.exercises.length;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _answeredCorrectly / total,
            minHeight: 10,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_inFixPhase)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: scheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_fix_high_rounded,
                                size: 20,
                                color: scheme.onTertiaryContainer),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Fix your mistake — try this one again',
                                style: TextStyle(
                                  color: scheme.onTertiaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      _ex.prompt,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700, height: 1.3),
                    ),
                    const SizedBox(height: 24),
                    ExerciseView(
                      key: ValueKey('${_ex.id}#$_answeredCorrectly#${_queue.length}'),
                      exercise: _ex,
                      draft: _draft,
                      locked: _checked,
                    ),
                  ],
                ),
              ),
            ),
            _FeedbackBar(
              checked: _checked,
              correct: _correct,
              explanation: _ex.explanation,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ValueListenableBuilder<Object?>(
                valueListenable: _draft,
                builder: (context, draft, _) {
                  final canCheck = draft != null &&
                      !(draft is List && draft.isEmpty) &&
                      !(draft is String && draft.trim().isEmpty);
                  if (_checked) {
                    return FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            _correct ? DailoTheme.seed : scheme.error,
                      ),
                      child: Text(
                        (_queue.length == 1 && _correct)
                            ? 'Finish'
                            : 'Continue',
                      ),
                    );
                  }
                  return FilledButton(
                    onPressed: canCheck ? _check : null,
                    child: const Text('Check'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackBar extends StatelessWidget {
  const _FeedbackBar({
    required this.checked,
    required this.correct,
    required this.explanation,
  });
  final bool checked;
  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    if (!checked) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final color = correct ? DailoTheme.seed : scheme.error;
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                correct ? 'Correct!' : 'Not quite',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ],
          ),
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(explanation,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  const _ResultScreen({
    required this.lesson,
    required this.perfect,
    required this.awardedXp,
  });
  final Lesson lesson;
  final bool perfect;
  final int awardedXp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                perfect ? Icons.emoji_events_rounded : Icons.check_circle_rounded,
                size: 96,
                color: perfect ? DailoTheme.xpGold : DailoTheme.seed,
              ),
              const SizedBox(height: 16),
              Text(
                perfect ? 'Perfect!' : 'Lesson complete!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        color: DailoTheme.xpGold, size: 32),
                    const SizedBox(height: 4),
                    Text(
                      awardedXp > 0 ? '+$awardedXp XP' : 'Reviewed',
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    if (perfect)
                      Text('No mistakes — bonus included!',
                          style: TextStyle(color: scheme.onPrimaryContainer)),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
