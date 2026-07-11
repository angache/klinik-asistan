import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../models/treatment_note.dart';
import '../models/voice_memo.dart';
import '../services/database_service.dart';
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
  List<TreatmentNote> _notes = [];
  List<VoiceMemo> _voices = [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final notes =
          await widget.db.getNotesForPatient(widget.patient.id);
      final voices =
          await widget.db.getVoiceMemosForPatient(widget.patient.id);
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _voices = voices;
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
      patient: widget.patient,
      db: widget.db,
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seans notu kaydedildi')),
      );
      await _reload();
    }
  }

  Future<void> _openVoiceRecord() async {
    final saved = await showVoiceRecordDialog(
      context: context,
      patient: widget.patient,
      db: widget.db,
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesli not kaydedildi')),
      );
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final patient = widget.patient;
    final phone = patient.telefon?.trim();
    final pending = _voices.where((v) => !v.islenen).toList();
    final done = _voices.where((v) => v.islenen).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.adSoyad),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'voice',
            onPressed: _openVoiceRecord,
            icon: const Icon(Icons.mic),
            label: const Text('Sesli Not'),
            backgroundColor: scheme.tertiaryContainer,
            foregroundColor: scheme.onTertiaryContainer,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'session',
            onPressed: _openNewSession,
            icon: const Icon(Icons.add),
            label: const Text('Yeni Seans'),
          ),
        ],
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

    final empty = _notes.isEmpty && _voices.isEmpty;
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
                patient: widget.patient,
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
                patient: widget.patient,
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
                patient: widget.patient,
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
