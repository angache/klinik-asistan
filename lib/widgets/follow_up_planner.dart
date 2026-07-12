import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Seans formunda kontrol planlama bloğu.
class FollowUpPlanner extends StatelessWidget {
  const FollowUpPlanner({
    super.key,
    required this.enabled,
    required this.onEnabledChanged,
    required this.presetDays,
    required this.onPresetChanged,
    required this.customDate,
    required this.onPickDate,
    required this.noteController,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final int? presetDays;
  final ValueChanged<int?> onPresetChanged;
  final DateTime? customDate;
  final VoidCallback onPickDate;
  final TextEditingController noteController;

  static DateTime dateFromPreset(int days) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day).add(Duration(days: days));
  }

  DateTime? get effectiveDate {
    if (!enabled) return null;
    if (presetDays != null) return dateFromPreset(presetDays!);
    return customDate;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd.MM.yyyy');

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Kontrol / takip planla'),
              subtitle: const Text('Günü gelince listede uyarır'),
              value: enabled,
              onChanged: onEnabledChanged,
            ),
            if (enabled) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('1 hafta'),
                    selected: presetDays == 7,
                    onSelected: (_) => onPresetChanged(7),
                  ),
                  ChoiceChip(
                    label: const Text('1 ay'),
                    selected: presetDays == 30,
                    onSelected: (_) => onPresetChanged(30),
                  ),
                  ChoiceChip(
                    label: const Text('3 ay'),
                    selected: presetDays == 90,
                    onSelected: (_) => onPresetChanged(90),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month, size: 16),
                    label: Text(
                      customDate != null && presetDays == null
                          ? fmt.format(customDate!)
                          : 'Tarih seç',
                    ),
                    onPressed: onPickDate,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Ne yapılacak?',
                  hintText: 'örn. Film çek, geçici kontrol…',
                  filled: true,
                  fillColor: scheme.surface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
