import 'package:flutter/material.dart';

import '../models/follow_up.dart';
import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../models/voice_memo.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../widgets/new_session_dialog.dart';
import '../widgets/treatment_note_tile.dart';
import '../widgets/voice_memo_tile.dart';
import '../widgets/voice_record_dialog.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({
    super.key,
    required this.patient,
    required this.db,
  });

  final Patient patient;
  final DatabaseService db;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Patient _patient;
  List<TreatmentNote> _notes = [];
  List<VoiceMemo> _voices = [];
  List<FollowUp> _followUps = [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        widget.db.getNotesForPatient(_patient.id),
        widget.db.getVoiceMemosForPatient(_patient.id),
        widget.db.getFollowUpsForPatient(_patient.id),
      ]);
      if (!mounted) return;
      setState(() {
        _notes = results[0] as List<TreatmentNote>;
        _voices = results[1] as List<VoiceMemo>;
        _followUps = (results[2] as List<FollowUp>)
            .where((followUp) => !followUp.tamamlandi)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _openNewSession() async {
    final saved = await showNewSessionDialog(
      context: context,
      patient: _patient,
      db: widget.db,
    );
    if (saved != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seans notu kaydedildi')),
      );
      await _reload();
    }
  }

  Future<void> _openVoiceRecord() async {
    final saved = await showVoiceRecordDialog(
      context: context,
      patient: _patient,
      db: widget.db,
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesli not kaydedildi')),
      );
      await _reload();
    }
  }

  Future<void> _editPatient() async {
    final nameCtrl = TextEditingController(text: _patient.adSoyad);
    final phoneCtrl = TextEditingController(text: _patient.telefon ?? '');
    final updated = await showDialog<Patient>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hastayı düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final patient = await widget.db.updatePatient(
                id: _patient.id,
                adSoyad: nameCtrl.text,
                telefon: phoneCtrl.text,
              );
              if (ctx.mounted) Navigator.pop(ctx, patient);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    if (updated != null && mounted) setState(() => _patient = updated);
  }

  Future<void> _deletePatient() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hastayı sil'),
        content: Text('${_patient.adSoyad} ve ilişkili kayıtları silinsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.db.deletePatient(_patient.id);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hasta silinemedi: $e')),
      );
    }
  }

  Future<void> _completeFollowUp(FollowUp followUp) async {
    try {
      await widget.db.completeFollowUp(followUp.id);
      await NotificationService.instance.cancelFollowUp(followUp.id);
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Takip tamamlanamadı: $e')),
      );
    }
  }

  Future<void> _deleteFollowUp(FollowUp followUp) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Takibi sil'),
        content: Text('${followUp.baslik} silinsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.db.deleteFollowUp(followUp.id);
      await NotificationService.instance.cancelFollowUp(followUp.id);
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Takip silinemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final patient = _patient;
    final phone = patient.telefon?.trim();
    final pending = _voices.where((v) => !v.islenen).toList();
    final done = _voices.where((v) => v.islenen).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.adSoyad),
        actions: [
          IconButton(
            tooltip: 'Sesli not',
            onPressed: _openVoiceRecord,
            icon: const Icon(Icons.mic_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') _editPatient();
              if (value == 'delete') _deletePatient();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              if (widget.db.canManageRecords)
                const PopupMenuItem(value: 'delete', child: Text('Sil')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewSession,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Seans'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text(
                      patient.adSoyad.isNotEmpty
                          ? patient.adSoyad[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.adSoyad,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (phone != null && phone.isNotEmpty)
                              ? phone
                              : 'Telefon yok',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildList(scheme, pending, done)),
        ],
      ),
    );
  }

  Widget _buildList(
    ColorScheme scheme,
    List<VoiceMemo> pending,
    List<VoiceMemo> done,
  ) {
    if (_loading && _notes.isEmpty && _voices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _notes.isEmpty && _voices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Veriler yüklenemedi: $_error',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.error),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _reload,
                child: const Text('Tekrar dene'),
              ),
            ],
          ),
        ),
      );
    }

    final empty = _notes.isEmpty && _voices.isEmpty && _followUps.isEmpty;
    if (empty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notes_outlined, size: 48, color: scheme.outline),
                    const SizedBox(height: 12),
                    Text(
                      'Henüz kayıt yok.\nSesli not veya seans ekleyin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          if (_followUps.isNotEmpty) ...[
            Text(
              'Açık takipler',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._followUps.map(
              (followUp) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(followUp.baslik),
                  subtitle: Text(
                    '${followUp.planDateOnly.day.toString().padLeft(2, '0')}.'
                    '${followUp.planDateOnly.month.toString().padLeft(2, '0')}.'
                    '${followUp.planDateOnly.year}',
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: 'Tamamla',
                        onPressed: () => _completeFollowUp(followUp),
                        icon: const Icon(Icons.check_circle_outline),
                      ),
                      IconButton(
                        tooltip: 'Sil',
                        onPressed: () => _deleteFollowUp(followUp),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (pending.isNotEmpty) ...[
            Text(
              'Bekleyen sesli notlar',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...pending.map(
              (m) => VoiceMemoTile(
                memo: m,
                patient: _patient,
                db: widget.db,
                onChanged: _reload,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            'Seans geçmişi',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (_notes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Henüz seans notu yok.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            )
          else
            ..._notes.map(
              (n) => TreatmentNoteTile(
                note: n,
                patient: _patient,
                db: widget.db,
                onChanged: _reload,
              ),
            ),
          if (done.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'İşlenmiş sesli notlar',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...done.map(
              (m) => VoiceMemoTile(
                memo: m,
                patient: _patient,
                db: widget.db,
                onChanged: _reload,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
