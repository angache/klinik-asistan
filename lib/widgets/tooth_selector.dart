import 'package:flutter/material.dart';

/// FDI odontogram — birden fazla diş seçilebilir.
class ToothSelector extends StatelessWidget {
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

  /// Chart sırasına göre (üst sağ→sol, alt sol→sağ üzerinden orta hat).
  static const List<String> allInChartOrder = [
    ...upperRight,
    ...upperLeft,
    ...lowerLeft,
    '41', '42', '43', '44', '45', '46', '47', '48',
  ];

  void _toggle(String tooth) {
    final next = Set<String>.from(selected);
    if (next.contains(tooth)) {
      next.remove(tooth);
    } else {
      next.add(tooth);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = formatToothSelection(selected);

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
            if (selected.isNotEmpty) ...[
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
                onPressed: () => onChanged({}),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Birden fazla diş için dokunarak seçin',
          style: textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(0.35),
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
                right: upperRight,
                left: upperLeft,
                selected: selected,
                onToggle: _toggle,
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
                right: lowerRight,
                left: lowerLeft,
                selected: selected,
                onToggle: _toggle,
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
            ],
          ),
        ),
      ],
    );
  }
}

/// Seçili dişleri klinik aralık formatına çevirir.
/// Örn. {14,15,16,17} → "14-17", {35,36,37,38,41,42,43,44,45} → "35-45"
String formatToothSelection(Iterable<String> teeth) {
  final set = teeth.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
  if (set.isEmpty) return '';
  if (set.length == 1) return set.first;

  // Üst ark sırası (18→28), alt ark sırası (38→48 üzerinden orta hat)
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

  // Hiçbir arkta yoksa (bozuk veri) düz sayısal aralık
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
      // Aynı kadranda artan numara (14-17); orta hat aşımında ark sırası (35-45)
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
        // Arc üzerinde a→b arasını doldur
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
  });

  final List<String> right;
  final List<String> left;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Quadrant(
            teeth: right,
            selected: selected,
            onToggle: onToggle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 1.5,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.outline,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        Expanded(
          child: _Quadrant(
            teeth: left,
            selected: selected,
            onToggle: onToggle,
          ),
        ),
      ],
    );
  }
}

class _Quadrant extends StatelessWidget {
  const _Quadrant({
    required this.teeth,
    required this.selected,
    required this.onToggle,
  });

  final List<String> teeth;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 3.0;
        final cell = (constraints.maxWidth - gap * 7) / 8;

        return Row(
          children: [
            for (var i = 0; i < teeth.length; i++) ...[
              if (i > 0) const SizedBox(width: gap),
              SizedBox(
                width: cell,
                height: 36,
                child: _ToothCell(
                  number: teeth[i],
                  isSelected: selected.contains(teeth[i]),
                  onTap: () => onToggle(teeth[i]),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ToothCell extends StatelessWidget {
  const _ToothCell({
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  final String number;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? scheme.primary : scheme.surface,
      borderRadius: BorderRadius.circular(8),
      elevation: isSelected ? 1 : 0,
      shadowColor: scheme.primary.withOpacity(0.35),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? scheme.onPrimary : scheme.onSurface,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
