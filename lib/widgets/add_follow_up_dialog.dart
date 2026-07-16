import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/follow_up.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

Future<FollowUp?> showAddFollowUpDialog({
  required BuildContext context,
  required Patient patient,
  required DatabaseService db,
}) {
  return showDialog<FollowUp>(
    context: context,
    builder: (_) => _AddFollowUpDialog(patient: patient, db: db),
  );
}

class _AddFollowUpDialog extends StatefulWidget {
  const _AddFollowUpDialog({
    required this.patient,
    required this.db,
  });

  final Patient patient;
  final DatabaseService db;

  @override
  State<_AddFollowUpDialog> createState() => _AddFollowUpDialogState();
}

class _AddFollowUpDialogState extends State<_AddFollowUpDialog> {
  final _baslik = TextEditingController();
  final _aciklama = TextEditingController();
  int? _presetDays = 7;
  DateTime? _customDate;
  bool _saving = false;

  @override
  void dispose() {
    _baslik.dispose();
    _aciklama.dispose();
    super.dispose();
  }

  DateTime get _effectiveDate {
    if (_presetDays != null) {
      final n = DateTime.now();
      return DateTime(n.year, n.month, n.day).add(Duration(days: _presetDays!));
    }
    final c = _customDate;
    if (c != null) return DateTime(c.year, c.month, c.day);
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _customDate ?? today.add(const Duration(days: 7)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 3)),
      helpText: 'Takip tarihi',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _customDate = picked;
      _presetDays = null;
    });
  }

  Future<void> _save() async {
    final title = _baslik.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Takip başlığı yazın')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final followUp = await widget.db.createFollowUp(
        hastaId: widget.patient.id,
        baslik: title,
        planlananTarih: _effectiveDate,
        aciklama: _aciklama.text.trim().isEmpty ? null : _aciklama.text.trim(),
        tur: 'genel',
      );
      await NotificationService.instance.scheduleFollowUp(followUp);
      if (!mounted) return;
      Navigator.pop(context, followUp);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kaydedilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd.MM.yyyy');
    return AlertDialog(
      title: const Text('Takip ekle'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _baslik,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Ne takip edilecek?',
                  hintText: 'örn. Kontrol, dikiş alma, ağrı kontrolü…',
                ),
                onSubmitted: (_) => _saving ? null : _save(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _aciklama,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Not (isteğe bağlı)',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ne zaman?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Bugün'),
                    selected: _presetDays == 0,
                    onSelected: (_) => setState(() {
                      _presetDays = 0;
                      _customDate = null;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('1 hafta'),
                    selected: _presetDays == 7,
                    onSelected: (_) => setState(() {
                      _presetDays = 7;
                      _customDate = null;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('1 ay'),
                    selected: _presetDays == 30,
                    onSelected: (_) => setState(() {
                      _presetDays = 30;
                      _customDate = null;
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('3 ay'),
                    selected: _presetDays == 90,
                    onSelected: (_) => setState(() {
                      _presetDays = 90;
                      _customDate = null;
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
              const SizedBox(height: 8),
              Text(
                'Hatırlatma: ${fmt.format(_effectiveDate)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}
