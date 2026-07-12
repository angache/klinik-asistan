import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum JawQuadrant {
  upperRight('Üst sağ', ToothSelector.upperRight),
  upperLeft('Üst sol', ToothSelector.upperLeft),
  lowerRight('Alt sağ', ToothSelector.lowerRight),
  lowerLeft('Alt sol', ToothSelector.lowerLeft);

  const JawQuadrant(this.label, this.teeth);
  final String label;
  final List<String> teeth;
}

/// FDI odontogram — chart, çeyrek büyütme ve yazarak seçim.
class ToothSelector extends StatefulWidget {
  const ToothSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  static const upperRight = ['18', '17', '16', '15', '14', '13', '12', '11'];
  static const upperLeft = ['21', '22', '23', '24', '25', '26', '27', '28'];
  static const lowerRight = ['48', '47', '46', '45', '44', '43', '42', '41'];
  static const lowerLeft = ['31', '32', '33', '34', '35', '36', '37', '38'];

  static const Set<String> allTeeth = {
    ...upperRight,
    ...upperLeft,
    ...lowerRight,
    ...lowerLeft,
  };

  /// Chart sırasına göre (üst sağ→sol, alt sol→sağ üzerinden orta hat).
  static const List<String> allInChartOrder = [
    ...upperRight,
    ...upperLeft,
    ...lowerLeft,
    '41', '42', '43', '44', '45', '46', '47', '48',
  ];

  @override
  State<ToothSelector> createState() => _ToothSelectorState();
}

class _ToothSelectorState extends State<ToothSelector> {
  late final TextEditingController _fdiCtrl;
  final _fdiFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fdiCtrl = TextEditingController(
      text: formatToothSelection(widget.selected),
    );
  }

  @override
  void didUpdateWidget(covariant ToothSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_fdiFocus.hasFocus) {
      final next = formatToothSelection(widget.selected);
      if (_fdiCtrl.text != next) {
        _fdiCtrl.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _fdiCtrl.dispose();
    _fdiFocus.dispose();
    super.dispose();
  }

  void _toggle(String tooth) {
    final next = Set<String>.from(widget.selected);
    if (next.contains(tooth)) {
      next.remove(tooth);
    } else {
      next.add(tooth);
    }
    widget.onChanged(next);
  }

  void _applyFdiText(String raw) {
    final parsed = parseToothSelection(raw)
        .where(ToothSelector.allTeeth.contains)
        .toSet();
    widget.onChanged(parsed);
    final pretty = formatToothSelection(parsed);
    if (_fdiCtrl.text != pretty) {
      _fdiCtrl.value = TextEditingValue(
        text: pretty,
        selection: TextSelection.collapsed(offset: pretty.length),
      );
    }
  }

  Future<void> _openQuadrant(JawQuadrant quadrant) async {
    HapticFeedback.mediumImpact();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return _QuadrantZoomSheet(
          quadrant: quadrant,
          selected: widget.selected,
          onChanged: widget.onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = formatToothSelection(widget.selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Diş Numarası',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (widget.selected.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Seçimi temizle',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  widget.onChanged({});
                  _fdiCtrl.clear();
                },
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _fdiCtrl,
          focusNode: _fdiFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Yazarak seç (FDI)',
            hintText: 'örn. 15  veya  14-17  veya  36,37',
            suffixIcon: IconButton(
              tooltip: 'Uygula',
              onPressed: () {
                _applyFdiText(_fdiCtrl.text);
                _fdiFocus.unfocus();
              },
              icon: const Icon(Icons.check),
            ),
          ),
          onSubmitted: (v) {
            _applyFdiText(v);
            _fdiFocus.unfocus();
          },
          onEditingComplete: () {
            _applyFdiText(_fdiCtrl.text);
            _fdiFocus.unfocus();
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Dokun: seç · Uzun bas: çeyreği büyüt · Aşağı kaydır veya Tamam: küçült',
          style: textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Text(
                'ÜST',
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              _ArchRow(
                right: JawQuadrant.upperRight,
                left: JawQuadrant.upperLeft,
                selected: widget.selected,
                onToggle: _toggle,
                onZoom: _openQuadrant,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sağ',
                        textAlign: TextAlign.left,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 14,
                      color: scheme.outline,
                    ),
                    Expanded(
                      child: Text(
                        'Sol',
                        textAlign: TextAlign.right,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _ArchRow(
                right: JawQuadrant.lowerRight,
                left: JawQuadrant.lowerLeft,
                selected: widget.selected,
                onToggle: _toggle,
                onZoom: _openQuadrant,
              ),
              const SizedBox(height: 8),
              Text(
                'ALT',
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: JawQuadrant.values.map((q) {
                  return ActionChip(
                    avatar: const Icon(Icons.zoom_in, size: 16),
                    label: Text(q.label),
                    onPressed: () => _openQuadrant(q),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Büyük çeyrek seçim paneli.
class _QuadrantZoomSheet extends StatelessWidget {
  const _QuadrantZoomSheet({
    required this.quadrant,
    required this.selected,
    required this.onChanged,
  });

  final JawQuadrant quadrant;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return _QuadrantZoomBody(
      quadrant: quadrant,
      initial: selected,
      onChanged: onChanged,
      bottomPadding: bottom,
      scheme: scheme,
    );
  }
}

class _QuadrantZoomBody extends StatefulWidget {
  const _QuadrantZoomBody({
    required this.quadrant,
    required this.initial,
    required this.onChanged,
    required this.bottomPadding,
    required this.scheme,
  });

  final JawQuadrant quadrant;
  final Set<String> initial;
  final ValueChanged<Set<String>> onChanged;
  final double bottomPadding;
  final ColorScheme scheme;

  @override
  State<_QuadrantZoomBody> createState() => _QuadrantZoomBodyState();
}

class _QuadrantZoomBodyState extends State<_QuadrantZoomBody> {
  late Set<String> _local;

  @override
  void initState() {
    super.initState();
    _local = Set<String>.from(widget.initial);
  }

  void _toggle(String tooth) {
    setState(() {
      if (_local.contains(tooth)) {
        _local.remove(tooth);
      } else {
        _local.add(tooth);
      }
    });
    widget.onChanged(Set<String>.from(_local));
  }

  @override
  Widget build(BuildContext context) {
    final label = formatToothSelection(
      _local.where(widget.quadrant.teeth.contains),
    );
    final teeth = widget.quadrant.teeth;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 16 + widget.bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.quadrant.label,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label.isEmpty ? 'Diş seçin' : 'Seçili: $label',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = 10.0;
                final cell = (constraints.maxWidth - gap * 3) / 4;
                final size = cell.clamp(56.0, 88.0);

                return Column(
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: gap),
                          SizedBox(
                            width: size,
                            height: size,
                            child: _ToothCell(
                              number: teeth[i],
                              isSelected: _local.contains(teeth[i]),
                              onTap: () => _toggle(teeth[i]),
                              large: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: gap),
                    Row(
                      children: [
                        for (var i = 4; i < 8; i++) ...[
                          if (i > 4) const SizedBox(width: gap),
                          SizedBox(
                            width: size,
                            height: size,
                            child: _ToothCell(
                              number: teeth[i],
                              isSelected: _local.contains(teeth[i]),
                              onTap: () => _toggle(teeth[i]),
                              large: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
            const SizedBox(height: 4),
            Text(
              'Aşağı kaydırarak da kapatabilirsiniz',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: widget.scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Seçili dişleri klinik aralık formatına çevirir.
String formatToothSelection(Iterable<String> teeth) {
  final set = teeth.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
  if (set.isEmpty) return '';
  if (set.length == 1) return set.first;

  const upperArc = [
    ...ToothSelector.upperRight,
    ...ToothSelector.upperLeft,
  ];
  const lowerArc = [
    ...ToothSelector.lowerLeft,
    '41', '42', '43', '44', '45', '46', '47', '48',
  ];

  final upperSel = upperArc.where(set.contains).toList();
  final lowerSel = lowerArc.where(set.contains).toList();
  final parts = <String>[];

  if (upperSel.isNotEmpty) {
    parts.addAll(_rangesAlongArc(upperArc, upperSel.toSet()));
  }
  if (lowerSel.isNotEmpty) {
    parts.addAll(_rangesAlongArc(lowerArc, lowerSel.toSet()));
  }

  if (parts.isEmpty) {
    final nums = set.map(int.parse).toList()..sort();
    return _numericRanges(nums);
  }

  return parts.join(', ');
}

List<String> _rangesAlongArc(List<String> arc, Set<String> selected) {
  final indices = <int>[];
  for (var i = 0; i < arc.length; i++) {
    if (selected.contains(arc[i])) indices.add(i);
  }
  if (indices.isEmpty) return [];

  final result = <String>[];
  var start = indices.first;
  var prev = indices.first;

  void flush(int end) {
    if (start == end) {
      result.add(arc[start]);
    } else {
      final a = arc[start];
      final b = arc[end];
      if (a[0] == b[0]) {
        final ai = int.parse(a);
        final bi = int.parse(b);
        result.add(ai < bi ? '$a-$b' : '$b-$a');
      } else {
        result.add('$a-$b');
      }
    }
  }

  for (var i = 1; i < indices.length; i++) {
    if (indices[i] == prev + 1) {
      prev = indices[i];
    } else {
      flush(prev);
      start = indices[i];
      prev = indices[i];
    }
  }
  flush(prev);
  return result;
}

String _numericRanges(List<int> sorted) {
  if (sorted.isEmpty) return '';
  final parts = <String>[];
  var start = sorted.first;
  var prev = sorted.first;

  void flush() {
    if (start == prev) {
      parts.add('$start');
    } else {
      parts.add('$start-$prev');
    }
  }

  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i] == prev + 1) {
      prev = sorted[i];
    } else {
      flush();
      start = sorted[i];
      prev = sorted[i];
    }
  }
  flush();
  return parts.join(', ');
}

/// Kayıtlı `dis_no` metnini Set'e çevirir ("14-17" veya "14,15,16").
Set<String> parseToothSelection(String? raw) {
  if (raw == null || raw.trim().isEmpty) return {};
  final result = <String>{};
  for (final part in raw.split(RegExp(r'[,;\s]+'))) {
    final p = part.trim();
    if (p.isEmpty) continue;
    if (p.contains('-')) {
      final bits = p.split('-');
      if (bits.length == 2) {
        final a = bits[0].trim();
        final b = bits[1].trim();
        for (final arc in [
          [
            ...ToothSelector.upperRight,
            ...ToothSelector.upperLeft,
          ],
          [
            ...ToothSelector.lowerLeft,
            '41', '42', '43', '44', '45', '46', '47', '48',
          ],
        ]) {
          final i = arc.indexOf(a);
          final j = arc.indexOf(b);
          if (i >= 0 && j >= 0) {
            final from = i < j ? i : j;
            final to = i < j ? j : i;
            result.addAll(arc.sublist(from, to + 1));
            break;
          }
        }
      }
    } else {
      result.add(p);
    }
  }
  return result;
}

class _ArchRow extends StatelessWidget {
  const _ArchRow({
    required this.right,
    required this.left,
    required this.selected,
    required this.onToggle,
    required this.onZoom,
  });

  final JawQuadrant right;
  final JawQuadrant left;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final ValueChanged<JawQuadrant> onZoom;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Quadrant(
            quadrant: right,
            selected: selected,
            onToggle: onToggle,
            onZoom: () => onZoom(right),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 1.5,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.outline,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        Expanded(
          child: _Quadrant(
            quadrant: left,
            selected: selected,
            onToggle: onToggle,
            onZoom: () => onZoom(left),
          ),
        ),
      ],
    );
  }
}

class _Quadrant extends StatelessWidget {
  const _Quadrant({
    required this.quadrant,
    required this.selected,
    required this.onToggle,
    required this.onZoom,
  });

  final JawQuadrant quadrant;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onZoom;

  @override
  Widget build(BuildContext context) {
    final teeth = quadrant.teeth;

    return GestureDetector(
      onLongPress: onZoom,
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 3.0;
          final cell = (constraints.maxWidth - gap * 7) / 8;
          final height = (cell * 1.25).clamp(28.0, 40.0);

          return Row(
            children: [
              for (var i = 0; i < teeth.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                SizedBox(
                  width: cell,
                  height: height,
                  child: _ToothCell(
                    number: teeth[i],
                    isSelected: selected.contains(teeth[i]),
                    onTap: () => onToggle(teeth[i]),
                    onLongPress: onZoom,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ToothCell extends StatelessWidget {
  const _ToothCell({
    required this.number,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    this.large = false,
  });

  final String number;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? scheme.primary : scheme.surface,
      borderRadius: BorderRadius.circular(large ? 14 : 8),
      elevation: isSelected ? 1 : 0,
      shadowColor: scheme.primary.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(large ? 14 : 8),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: large ? 4 : 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(large ? 14 : 8),
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
              width: large ? 1.5 : 1,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              number,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: large ? 22 : 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? scheme.onPrimary : scheme.onSurface,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
