import 'package:flutter/material.dart';

import '../../content/content_loader.dart';
import '../../main.dart';
import '../../models/course.dart';
import 'lesson_player.dart';

/// Shows the 10 lessons inside a unit; lessons unlock sequentially.
class UnitScreen extends StatelessWidget {
  const UnitScreen({
    super.key,
    required this.courseId,
    required this.course,
    required this.unit,
    required this.loader,
  });

  final String courseId;
  final Course course;
  final Unit unit;
  final ContentLoader loader;

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(unit.title)),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: unit.lessons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final lesson = unit.lessons[i];
              final done = store.isLessonComplete(courseId, lesson.id);
              final unlocked = store.isLessonUnlocked(courseId, unit, i);
              final scheme = Theme.of(context).colorScheme;

              final Widget leading;
              if (done) {
                leading = CircleAvatar(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  child: const Icon(Icons.check_rounded),
                );
              } else if (unlocked) {
                leading = CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text('${i + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                );
              } else {
                leading = CircleAvatar(
                  backgroundColor: scheme.surfaceContainerHighest,
                  foregroundColor:
                      scheme.onSurfaceVariant.withValues(alpha: 0.5),
                  child: const Icon(Icons.lock_rounded),
                );
              }

              final subtitle = done
                  ? 'Completed'
                  : unlocked
                      ? '10 questions'
                      : 'Finish the previous lesson first';

              return Card(
                color: scheme.surfaceContainerLow,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  enabled: unlocked,
                  leading: leading,
                  title: Text(lesson.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: unlocked
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant.withValues(alpha: 0.6),
                      )),
                  subtitle: Text(subtitle),
                  trailing: unlocked
                      ? const Icon(Icons.chevron_right_rounded)
                      : Icon(Icons.lock_rounded,
                          size: 18, color: scheme.onSurfaceVariant),
                  onTap: !unlocked
                      ? null
                      : () async {
                          final full = await loader.loadLesson(lesson);
                          if (!context.mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LessonPlayer(
                                courseId: courseId,
                                lesson: full,
                              ),
                            ),
                          );
                        },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
