import 'package:flutter/material.dart';

import '../../content/catalog.dart';
import '../../content/content_loader.dart';
import '../../core/theme.dart';
import '../../main.dart';
import '../../models/course.dart';
import '../lesson/unit_screen.dart';

/// Loads a course's structure, then shows its skill-tree home. Used when the
/// learner opens one of their enrolled courses.
class CourseHomeLoader extends StatefulWidget {
  const CourseHomeLoader({
    super.key,
    required this.entry,
    required this.loader,
  });
  final CatalogEntry entry;
  final ContentLoader loader;

  @override
  State<CourseHomeLoader> createState() => _CourseHomeLoaderState();
}

class _CourseHomeLoaderState extends State<CourseHomeLoader> {
  late final Future<Course> _future = widget.loader.loadCourse();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Course>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Could not load course:\n${snap.error}')),
          );
        }
        return HomeScreen(
          courseId: widget.entry.id,
          course: snap.data!,
          loader: widget.loader,
        );
      },
    );
  }
}

/// A course's skill-tree home: gamification header + vertical path of units
/// grouped by lap, with locked / available / completed states.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.courseId,
    required this.course,
    required this.loader,
  });

  final String courseId;
  final Course course;
  final ContentLoader loader;

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header(courseId: courseId, course: course)),
              ..._buildLapSlivers(context),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildLapSlivers(BuildContext context) {
    final store = ProgressScope.of(context);
    final widgets = <Widget>[];
    for (final lap in course.laps) {
      widgets.add(SliverToBoxAdapter(child: _LapHeader(lap: lap)));
      final units = lap.unitIds
          .map((id) => course.units.where((u) => u.id == id))
          .where((it) => it.isNotEmpty)
          .map((it) => it.first)
          .toList();
      widgets.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final unit = units[i];
              final unlocked = store.isUnitUnlocked(courseId, course, unit);
              final complete = store.isUnitComplete(courseId, unit);
              return _UnitNode(
                unit: unit,
                index: i,
                unlocked: unlocked,
                complete: complete,
                onTap: unlocked
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UnitScreen(
                              courseId: courseId,
                              course: course,
                              unit: unit,
                              loader: loader,
                            ),
                          ),
                        )
                    : null,
              );
            },
            childCount: units.length,
          ),
        ),
      );
    }
    return widgets;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.courseId, required this.course});
  final String courseId;
  final Course course;

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (earned, needed) = store.levelProgress(courseId);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.75)],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: scheme.onPrimary),
                onPressed: () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  course.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                icon: Icons.local_fire_department_rounded,
                color: DailoTheme.streakFlame,
                label: 'Streak',
                value: '${store.streak(courseId)}',
                onPrimary: scheme.onPrimary,
              ),
              const SizedBox(width: 12),
              _Stat(
                icon: Icons.bolt_rounded,
                color: DailoTheme.xpGold,
                label: 'XP',
                value: '${store.xp(courseId)}',
                onPrimary: scheme.onPrimary,
              ),
              const SizedBox(width: 12),
              _Stat(
                icon: Icons.star_rounded,
                color: Colors.white,
                label: 'Level',
                value: '${store.level(courseId)}',
                onPrimary: scheme.onPrimary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: needed == 0 ? 0 : earned / needed,
              minHeight: 10,
              backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(DailoTheme.xpGold),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Level ${store.level(courseId)}  ·  $earned / $needed XP',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onPrimary,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    color: onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(
                    color: onPrimary.withValues(alpha: 0.85), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _LapHeader extends StatelessWidget {
  const _LapHeader({required this.lap});
  final Lap lap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Lap ${lap.id}',
                style: TextStyle(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(lap.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _UnitNode extends StatelessWidget {
  const _UnitNode({
    required this.unit,
    required this.index,
    required this.unlocked,
    required this.complete,
    required this.onTap,
  });

  final Unit unit;
  final int index;
  final bool unlocked;
  final bool complete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final align = index.isEven ? Alignment.centerLeft : Alignment.centerRight;

    final Color bg;
    final Color fg;
    final IconData icon;
    if (complete) {
      bg = DailoTheme.seed;
      fg = Colors.white;
      icon = Icons.check_rounded;
    } else if (unlocked) {
      bg = scheme.primaryContainer;
      fg = scheme.onPrimaryContainer;
      icon = _beatIcon(unit.beat);
    } else {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurfaceVariant.withValues(alpha: 0.5);
      icon = Icons.lock_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Align(
        alignment: align,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Material(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: bg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: fg, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: unlocked
                                      ? scheme.onSurface
                                      : scheme.onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            unlocked ? unit.beat : 'Locked',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _beatIcon(String beat) {
    switch (beat) {
      case 'MEET':
        return Icons.lightbulb_outline_rounded;
      case 'TOOL':
        return Icons.build_rounded;
      case 'PRACTICE':
        return Icons.fitness_center_rounded;
      case 'LOOP':
        return Icons.refresh_rounded;
      default:
        return Icons.play_arrow_rounded;
    }
  }
}
