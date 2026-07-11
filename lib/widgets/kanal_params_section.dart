import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/tooth_canals.dart';
import '../data/treatment_templates.dart';

class KanalParamsSection extends StatelessWidget {
  const KanalParamsSection({
    super.key,
    required this.canalCodes,
    required this.typicalCodes,
    required this.kanalControllers,
    required this.selectedEge,
    required this.selectedIlac,
    required this.onEgeChanged,
    required this.onIlacChanged,
    required this.onAddCanal,
    required this.onRemoveExtraCanal,
    this.toothLabel,
  });

  final List<String> canalCodes;
  final List<String> typicalCodes;
  final Map<String, TextEditingController> kanalControllers;
  final String? selectedEge;
  final String? selectedIlac;
  final ValueChanged<String> onEgeChanged;
  final ValueChanged<String> onIlacChanged;
  final VoidCallback onAddCanal;
  final ValueChanged<String> onRemoveExtraCanal;
  final String? toothLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final codes = canalCodes.isEmpty ? kKanalKodlari : canalCodes;
    final typical = typicalCodes.toSet();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science_outlined, size: 18, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  toothLabel != null
                      ? 'Kanal parametreleri · Diş $toothLabel'
                      : 'Kanal Tedavisi Parametreleri',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                ),
              ),
            ],
          ),
          if (toothLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              toothCanalHint(toothLabel),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Kanal Boyu (mm)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              ...codes.map((kod) {
                final isExtra = !typical.contains(kod);
                return SizedBox(
                  width: 78,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isExtra)
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => onRemoveExtraCanal(kod),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 16),
                      TextField(
                        controller: kanalControllers[kod],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: kod,
                          isDense: true,
                          filled: isExtra,
                          fillColor: isExtra
                              ? scheme.tertiaryContainer.withValues(alpha: 0.45)
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: OutlinedButton.icon(
                  onPressed: onAddCanal,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Ekstra'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Eğe Sistemi', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kEgeSistemleri.map((ege) {
              return ChoiceChip(
                label: Text(ege),
                selected: selectedEge == ege,
                onSelected: (_) => onEgeChanged(ege),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Text('Kanal İçi İlaç', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kKanalIlaclari.map((ilac) {
              return ChoiceChip(
                label: Text(ilac),
                selected: selectedIlac == ilac,
                onSelected: (_) => onIlacChanged(ilac),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Dolu kanal boylarından "MB: 19mm, P: 21mm" formatı.
String buildKanalBoyuText(
  Map<String, TextEditingController> controllers, {
  List<String>? onlyCodes,
}) {
  final codes = onlyCodes ?? controllers.keys.toList();
  final parts = <String>[];
  for (final kod in codes) {
    final v = controllers[kod]?.text.trim() ?? '';
    if (v.isNotEmpty) {
      parts.add('$kod: ${v}mm');
    }
  }
  return parts.join(', ');
}
