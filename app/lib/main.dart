import 'package:flutter/material.dart';

import 'content/catalog.dart';
import 'content/content_loader.dart';
import 'core/theme.dart';
import 'data/progress_store.dart';
import 'features/courses/my_courses_screen.dart';

void main() {
  runApp(const DailoApp());
}

/// Exposes the shared [ProgressStore] to the whole widget tree (including
/// pushed routes) and rebuilds listeners when progress changes.
class ProgressScope extends InheritedNotifier<ProgressStore> {
  const ProgressScope({
    super.key,
    required ProgressStore store,
    required super.child,
  }) : super(notifier: store);

  static ProgressStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProgressScope>();
    assert(scope != null, 'No ProgressScope found in context');
    return scope!.notifier!;
  }
}

class DailoApp extends StatefulWidget {
  const DailoApp({super.key, this.catalog, this.loaderFactory});

  /// Test hooks: inject a pre-seeded catalog and/or a loader factory so the app
  /// can run with no real asset I/O (default: real asset-backed).
  final CatalogLoader? catalog;
  final ContentLoader Function(CatalogEntry entry)? loaderFactory;

  @override
  State<DailoApp> createState() => _DailoAppState();
}

class _DailoAppState extends State<DailoApp> {
  late final CatalogLoader _catalog = widget.catalog ?? CatalogLoader();
  final _store = ProgressStore();
  late final Future<void> _bootstrap = _store.load();

  @override
  Widget build(BuildContext context) {
    return ProgressScope(
      store: _store,
      child: MaterialApp(
        title: 'Dailo',
        debugShowCheckedModeBanner: false,
        theme: DailoTheme.light(),
        darkTheme: DailoTheme.dark(),
        home: FutureBuilder<void>(
          future: _bootstrap,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const _SplashLoader();
            }
            return MyCoursesScreen(
              catalog: _catalog,
              loaderFactory: widget.loaderFactory,
            );
          },
        ),
      ),
    );
  }
}

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(Icons.code_rounded,
                  size: 52, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: 24),
            Text('Dailo',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Learn, one bite at a time',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
