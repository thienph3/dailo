import 'package:flutter/material.dart';

import '../../content/catalog.dart';
import '../../content/content_loader.dart';
import '../../core/theme.dart';
import '../../main.dart';
import '../home/home_screen.dart';
import 'catalog_screen.dart';

/// Dailo's platform landing: the learner's enrolled courses. If none are
/// enrolled yet, the catalog is opened immediately and the first course must be
/// added before anything else.
class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key, required this.catalog, this.loaderFactory});
  final CatalogLoader catalog;

  /// Test hook: build a (possibly seeded) ContentLoader for a course. Defaults
  /// to a real asset-backed loader.
  final ContentLoader Function(CatalogEntry entry)? loaderFactory;

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  List<CatalogEntry> _all = const [];
  bool _loading = true;
  bool _openedForcedCatalog = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _all = await widget.catalog.load();
    if (!mounted) return;
    setState(() => _loading = false);
    _maybeForceCatalog();
  }

  /// If the learner has no courses, push the catalog right away — they must add
  /// a first course to proceed.
  void _maybeForceCatalog() {
    final store = ProgressScope.of(context);
    if (!store.hasAnyCourse && !_openedForcedCatalog) {
      _openedForcedCatalog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openCatalog(force: true));
    }
  }

  Future<void> _openCatalog({bool force = false}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CatalogScreen(catalog: widget.catalog, force: force),
      ),
    );
    // Returning from a forced catalog with still no course? Re-force it.
    if (!mounted) return;
    _openedForcedCatalog = false;
    _maybeForceCatalog();
  }

  void _openCourse(CatalogEntry entry) {
    final loader = widget.loaderFactory?.call(entry) ??
        ContentLoader(
          coursePath: entry.coursePath,
          contentBase: entry.contentBase,
        );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseHomeLoader(entry: entry, loader: loader),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final enrolled = store.enrolledCourseIds
            .map((id) => _all.where((c) => c.id == id))
            .where((it) => it.isNotEmpty)
            .map((it) => it.first)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dailo',
                style: TextStyle(fontWeight: FontWeight.w800)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add a course',
                onPressed: _loading ? null : () => _openCatalog(),
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : enrolled.isEmpty
                  ? _EmptyState(onAdd: () => _openCatalog(force: true))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                          child: Text('My courses',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                        for (final entry in enrolled)
                          _CourseCard(
                            entry: entry,
                            xp: store.xp(entry.id),
                            level: store.level(entry.id),
                            streak: store.streak(entry.id),
                            onTap: () => _openCourse(entry),
                          ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _openCatalog(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add another course'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
          backgroundColor: scheme.surface,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books_outlined,
                size: 72, color: scheme.primary),
            const SizedBox(height: 16),
            Text('Add your first course',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Pick a course to start learning. You can add more any time.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Browse courses'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.entry,
    required this.xp,
    required this.level,
    required this.streak,
    required this.onTap,
  });
  final CatalogEntry entry;
  final int xp;
  final int level;
  final int streak;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: entry.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(entry.icon, color: entry.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text(entry.subtitle,
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _mini(context, Icons.local_fire_department_rounded,
                        DailoTheme.streakFlame, '$streak', 'streak'),
                    const SizedBox(width: 16),
                    _mini(context, Icons.bolt_rounded, DailoTheme.xpGold,
                        '$xp', 'XP'),
                    const SizedBox(width: 16),
                    _mini(context, Icons.star_rounded, scheme.primary,
                        '$level', 'level'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mini(BuildContext context, IconData icon, Color color, String value,
      String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text('$value ',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
