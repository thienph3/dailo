import 'package:flutter/material.dart';

import '../../content/catalog.dart';
import '../../main.dart';

/// Browse available courses and add (enroll in) them. When [force] is true the
/// learner has no courses yet and must add one — back navigation is blocked
/// until they do.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.catalog, this.force = false});
  final CatalogLoader catalog;
  final bool force;

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return PopScope(
      // Block leaving a forced catalog until at least one course is enrolled.
      canPop: !force || store.hasAnyCourse,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course catalog'),
              automaticallyImplyLeading: !force || store.hasAnyCourse,
            ),
            body: FutureBuilder<List<CatalogEntry>>(
              future: catalog.load(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snap.data!;
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (force)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Add your first course to get started',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    for (final entry in entries)
                      _CatalogCard(
                        entry: entry,
                        enrolled: store.isEnrolled(entry.id),
                        onAdd: () async {
                          await store.enroll(entry.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added "${entry.title}"')),
                          );
                          // After adding the first (forced) course, close the
                          // catalog so the learner lands on My Courses.
                          if (force) Navigator.of(context).maybePop();
                        },
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.entry,
    required this.enrolled,
    required this.onAdd,
  });
  final CatalogEntry entry;
  final bool enrolled;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: scheme.surfaceContainerLow,
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
                ],
              ),
              const SizedBox(height: 12),
              Text(entry.description,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: enrolled
                    ? OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Added'),
                      )
                    : FilledButton.icon(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add course'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
