import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Yeni işlem formundan seçilen takip özeti.
class SessionFollowUpDraft {
  const SessionFollowUpDraft({
    required this.note,
    required this.controlDate,
    required this.reminderDaysBefore,
  });

  final String note;
  final DateTime controlDate;
  final int reminderDaysBefore;

  DateTime get reminderDate =>
      controlDate.subtract(Duration(days: reminderDaysBefore));

  String get summary {
    final fmt = DateFormat('dd.MM.yyyy');
    final when = reminderDaysBefore == 0
        ? 'kontrol günü uyar'
        : reminderDaysBefore == 1
            ? '1 gün önce uyar'
            : reminderDaysBefore == 7
                ? '1 hafta önce uyar'
                : '$reminderDaysBefore gün önce uyar';
    return '${fmt.format(controlDate)} · $when';
  }
}

Future<SessionFollowUpDraft?> showSessionFollowUpSheet({
  required BuildContext context,
  required DateTime sessionDate,
  SessionFollowUpDraft? initial,
}) {
  return showModalBottomSheet<SessionFollowUpDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _SessionFollowUpSheet(
      sessionDate: sessionDate,
      initial: initial,
    ),
  );
}

class _SessionFollowUpSheet extends StatefulWidget {
  const _SessionFollowUpSheet({
    required this.sessionDate,
    this.initial,
  });

  final DateTime sessionDate;
  final SessionFollowUpDraft? initial;

  @override
  State<_SessionFollowUpSheet> createState() => _SessionFollowUpSheetState();
}

class _SessionFollowUpSheetState extends State<_SessionFollowUpSheet> {
  late final TextEditingController _note;
  int? _presetDays;
  DateTime? _customDate;
  late int _reminderDays;
  String? _error;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _note = TextEditingController(text: initial?.note ?? '');
    _reminderDays = initial?.reminderDaysBefore ?? 1;
    if (initial != null) {
      final delta = initial.controlDate.difference(widget.sessionDate).inDays;
      if (const {7, 30, 90, 180}.contains(delta)) {
        _presetDays = delta;
        _customDate = null;
      } else {
        _presetDays = null;
        _customDate = initial.controlDate;
      }
    } else {
      _presetDays = 30;
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  DateTime? get _effectiveDate {
    if (_presetDays != null) {
      return widget.sessionDate.add(Duration(days: _presetDays!));
    }
    final c = _customDate;
    if (c == null) return null;
    return DateTime(c.year, c.month, c.day);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial =
        _customDate ?? widget.sessionDate.add(const Duration(days: 30));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 3)),
      helpText: 'Kontrol tarihi',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _customDate = picked;
      _presetDays = null;
      _error = null;
    });
  }

  void _confirm() {
    final note = _note.text.trim();
    final date = _effectiveDate;
    if (note.isEmpty) {
      setState(() => _error = 'Takip notunu yazın');
      return;
    }
    if (date == null) {
      setState(() => _error = 'Kontrol tarihini seçin');
      return;
    }
    Navigator.pop(
      context,
      SessionFollowUpDraft(
        note: note,
        controlDate: date,
        reminderDaysBefore: _reminderDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd.MM.yyyy');
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Takip oluştur',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kontrol tarihi ve uyarı zamanını seçin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _note,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Takip notu',
                hintText: 'örn. Perküsyon ve radyografik kontrol',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kontrol tarihi',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in const [
                  (7, '1 hafta'),
                  (30, '1 ay'),
                  (90, '3 ay'),
                  (180, '6 ay'),
                ])
                  ChoiceChip(
                    label: Text(option.$2),
                    selected: _presetDays == option.$1,
                    onSelected: (_) => setState(() {
                      _presetDays = option.$1;
                      _customDate = null;
                      _error = null;
                    }),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_month, size: 16),
                  label: Text(
                    _customDate != null && _presetDays == null
                        ? fmt.format(_customDate!)
                        : 'Tarih seç',
                  ),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _reminderDays,
              decoration: const InputDecoration(
                labelText: 'Ne zaman uyarılsın?',
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Kontrol günü')),
                DropdownMenuItem(value: 1, child: Text('1 gün önce')),
                DropdownMenuItem(value: 3, child: Text('3 gün önce')),
                DropdownMenuItem(value: 7, child: Text('1 hafta önce')),
              ],
              onChanged: (value) => setState(() {
                _reminderDays = value ?? 1;
              }),
            ),
            if (_effectiveDate != null) ...[
              const SizedBox(height: 10),
              Text(
                'Kontrol: ${fmt.format(_effectiveDate!)} · '
                'Uyarı: ${fmt.format(_effectiveDate!.subtract(Duration(days: _reminderDays)))}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _confirm,
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
