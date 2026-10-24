import 'package:flutter/material.dart';

import '../../models/course.dart';

/// Pure answer-checking logic for each exercise type. [draft] is the value the
/// learner produced (shape depends on type).
class ExerciseChecker {
  static bool isCorrect(Exercise ex, Object? draft) {
    switch (ex.type) {
      case ExerciseType.multipleChoice:
        return draft is int && draft == (ex.answer as num).toInt();
      case ExerciseType.trueFalse:
        return draft is bool && draft == (ex.answer as bool);
      case ExerciseType.multiSelect:
        if (draft is! Set<int>) return false;
        final want = (ex.answer as List).map((e) => (e as num).toInt()).toSet();
        return draft.length == want.length && draft.containsAll(want);
      case ExerciseType.fillBlank:
        if (draft is! String) return false;
        final given = draft.trim();
        final accepted = <String>{
          if (ex.answer is String) (ex.answer as String).trim(),
          ...ex.acceptable.map((a) => a.trim()),
        };
        return accepted.any((a) => a == given) ||
            accepted.any((a) => a.toLowerCase() == given.toLowerCase());
      case ExerciseType.orderBlocks:
        if (draft is! List) return false;
        final want = (ex.answer as List).map((e) => (e as num).toInt()).toList();
        if (draft.length != want.length) return false;
        for (var i = 0; i < want.length; i++) {
          if ((draft[i] as num).toInt() != want[i]) return false;
        }
        return true;
      case ExerciseType.tapTokens:
        if (draft is! List) return false;
        final want = (ex.answer as List).map((e) => e.toString()).toList();
        if (draft.length != want.length) return false;
        for (var i = 0; i < want.length; i++) {
          if (draft[i].toString() != want[i]) return false;
        }
        return true;
      case ExerciseType.matchPairs:
        if (draft is! Map) return false;
        // draft maps left -> right as chosen by the learner.
        for (final p in ex.pairs) {
          if (draft[p.left] != p.right) return false;
        }
        return true;
    }
  }
}

/// Dispatches to the right interactive widget for an exercise type.
class ExerciseView extends StatelessWidget {
  const ExerciseView({
    super.key,
    required this.exercise,
    required this.draft,
    required this.locked,
  });

  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    switch (exercise.type) {
      case ExerciseType.multipleChoice:
        return _ChoiceView(exercise: exercise, draft: draft, locked: locked);
      case ExerciseType.trueFalse:
        return _TrueFalseView(draft: draft, locked: locked);
      case ExerciseType.multiSelect:
        return _MultiSelectView(
            exercise: exercise, draft: draft, locked: locked);
      case ExerciseType.fillBlank:
        return _FillBlankView(draft: draft, locked: locked);
      case ExerciseType.orderBlocks:
        return _OrderBlocksView(
            exercise: exercise, draft: draft, locked: locked);
      case ExerciseType.tapTokens:
        return _TapTokensView(exercise: exercise, draft: draft, locked: locked);
      case ExerciseType.matchPairs:
        return _MatchPairsView(
            exercise: exercise, draft: draft, locked: locked);
    }
  }
}

// ---------- shared option tile ----------

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: locked ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontFamily: _looksLikeCode(label) ? 'monospace' : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _looksLikeCode(String s) =>
    s.contains('(') ||
    s.contains('=') ||
    s.contains('print') ||
    s.contains('[');

// ---------- multipleChoice ----------

class _ChoiceView extends StatelessWidget {
  const _ChoiceView(
      {required this.exercise, required this.draft, required this.locked});
  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object?>(
      valueListenable: draft,
      builder: (context, value, _) {
        return Column(
          children: [
            for (var i = 0; i < exercise.options.length; i++)
              _OptionTile(
                label: exercise.options[i],
                selected: value == i,
                locked: locked,
                onTap: () => draft.value = i,
              ),
          ],
        );
      },
    );
  }
}

// ---------- trueFalse ----------

class _TrueFalseView extends StatelessWidget {
  const _TrueFalseView({required this.draft, required this.locked});
  final ValueNotifier<Object?> draft;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object?>(
      valueListenable: draft,
      builder: (context, value, _) {
        return Row(
          children: [
            Expanded(
              child: _OptionTile(
                label: 'True',
                selected: value == true,
                locked: locked,
                onTap: () => draft.value = true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OptionTile(
                label: 'False',
                selected: value == false,
                locked: locked,
                onTap: () => draft.value = false,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------- multiSelect ----------

class _MultiSelectView extends StatelessWidget {
  const _MultiSelectView(
      {required this.exercise, required this.draft, required this.locked});
  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object?>(
      valueListenable: draft,
      builder: (context, value, _) {
        final selected = (value is Set<int>) ? value : <int>{};
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.checklist_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Select all that apply',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            for (var i = 0; i < exercise.options.length; i++)
              _OptionTile(
                label: exercise.options[i],
                selected: selected.contains(i),
                locked: locked,
                onTap: () {
                  final next = {...selected};
                  if (next.contains(i)) {
                    next.remove(i);
                  } else {
                    next.add(i);
                  }
                  draft.value = next;
                },
              ),
          ],
        );
      },
    );
  }
}

// ---------- fillBlank ----------

class _FillBlankView extends StatefulWidget {
  const _FillBlankView({required this.draft, required this.locked});
  final ValueNotifier<Object?> draft;
  final bool locked;
  @override
  State<_FillBlankView> createState() => _FillBlankViewState();
}

class _FillBlankViewState extends State<_FillBlankView> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => widget.draft.value = _controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: !widget.locked,
      autofocus: true,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 18),
      decoration: InputDecoration(
        hintText: 'Type your answer',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ---------- orderBlocks ----------

class _OrderBlocksView extends StatefulWidget {
  const _OrderBlocksView(
      {required this.exercise, required this.draft, required this.locked});
  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;
  @override
  State<_OrderBlocksView> createState() => _OrderBlocksViewState();
}

class _OrderBlocksViewState extends State<_OrderBlocksView> {
  late List<int> _order; // indices into exercise.blocks, current arrangement

  @override
  void initState() {
    super.initState();
    _order = List<int>.generate(widget.exercise.blocks.length, (i) => i);
    // The blocks are presented in their file order; the learner reorders them.
    // Report the current order immediately so "Check" can enable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.draft.value = List<int>.from(_order);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.drag_indicator_rounded,
                  size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text('Drag the lines into the right order',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: !widget.locked,
          onReorder: (oldIndex, newIndex) {
            if (widget.locked) return;
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = _order.removeAt(oldIndex);
              _order.insert(newIndex, item);
              widget.draft.value = List<int>.from(_order);
            });
          },
          children: [
            for (var pos = 0; pos < _order.length; pos++)
              Container(
                key: ValueKey(_order[pos]),
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.exercise.blocks[_order[pos]],
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 15),
                      ),
                    ),
                    Icon(Icons.drag_handle_rounded,
                        color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ---------- tapTokens ----------

class _TapTokensView extends StatefulWidget {
  const _TapTokensView(
      {required this.exercise, required this.draft, required this.locked});
  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;
  @override
  State<_TapTokensView> createState() => _TapTokensViewState();
}

class _TapTokensViewState extends State<_TapTokensView> {
  final List<int> _chosen = []; // indices into the shuffled bank
  late List<String> _bank;

  @override
  void initState() {
    super.initState();
    _bank = List<String>.from(widget.exercise.tokens)..shuffle();
  }

  void _report() {
    widget.draft.value = _chosen.map((i) => _bank[i]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Answer area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final i in _chosen)
                _TokenChip(
                  label: _bank[i],
                  onTap: widget.locked
                      ? null
                      : () {
                          setState(() {
                            _chosen.remove(i);
                            _report();
                          });
                        },
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Token bank
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _bank.length; i++)
              if (!_chosen.contains(i))
                _TokenChip(
                  label: _bank[i],
                  outlined: true,
                  onTap: widget.locked
                      ? null
                      : () {
                          setState(() {
                            _chosen.add(i);
                            _report();
                          });
                        },
                ),
          ],
        ),
      ],
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip(
      {required this.label, this.onTap, this.outlined = false});
  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: outlined ? scheme.surface : scheme.primaryContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: outlined ? scheme.outline : scheme.primary,
            ),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// ---------- matchPairs ----------

class _MatchPairsView extends StatefulWidget {
  const _MatchPairsView(
      {required this.exercise, required this.draft, required this.locked});
  final Exercise exercise;
  final ValueNotifier<Object?> draft;
  final bool locked;
  @override
  State<_MatchPairsView> createState() => _MatchPairsViewState();
}

class _MatchPairsViewState extends State<_MatchPairsView> {
  late List<String> _rights; // shuffled right-side options
  final Map<String, String> _matches = {}; // left -> chosen right
  String? _activeLeft;

  @override
  void initState() {
    super.initState();
    _rights = widget.exercise.pairs.map((p) => p.right).toList()..shuffle();
  }

  void _report() => widget.draft.value = Map<String, String>.from(_matches);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lefts = widget.exercise.pairs.map((p) => p.left).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.swap_horiz_rounded,
                  size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text('Tap a left item, then its match',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Column(
                children: [
                  for (final left in lefts)
                    _MatchCell(
                      label: left,
                      active: _activeLeft == left,
                      done: _matches.containsKey(left),
                      subtitle: _matches[left],
                      locked: widget.locked,
                      onTap: () => setState(() => _activeLeft = left),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right column
            Expanded(
              child: Column(
                children: [
                  for (final right in _rights)
                    _MatchCell(
                      label: right,
                      active: false,
                      done: _matches.containsValue(right),
                      locked: widget.locked,
                      onTap: () {
                        if (_activeLeft == null) return;
                        setState(() {
                          // remove any existing mapping to this right
                          _matches.removeWhere((k, v) => v == right);
                          _matches[_activeLeft!] = right;
                          _activeLeft = null;
                          _report();
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MatchCell extends StatelessWidget {
  const _MatchCell({
    required this.label,
    required this.active,
    required this.done,
    required this.locked,
    required this.onTap,
    this.subtitle,
  });
  final String label;
  final bool active;
  final bool done;
  final bool locked;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color bg = active
        ? scheme.primary
        : done
            ? scheme.primaryContainer
            : scheme.surfaceContainerLow;
    final Color fg = active ? scheme.onPrimary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : onTap,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('→ $subtitle',
                        style: TextStyle(
                            color: fg.withValues(alpha: 0.8), fontSize: 12)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
