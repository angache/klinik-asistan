import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../models/patient.dart';
import '../services/database_service.dart';

Future<bool?> showVoiceRecordDialog({
  required BuildContext context,
  required Patient patient,
  required DatabaseService db,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => VoiceRecordDialog(patient: patient, db: db),
  );
}

class VoiceRecordDialog extends StatefulWidget {
  const VoiceRecordDialog({
    super.key,
    required this.patient,
    required this.db,
  });

  final Patient patient;
  final DatabaseService db;

  @override
  State<VoiceRecordDialog> createState() => _VoiceRecordDialogState();
}

class _VoiceRecordDialogState extends State<VoiceRecordDialog> {
  final _recorder = AudioRecorder();
  bool _recording = false;
  bool _saving = false;
  int _elapsedSec = 0;
  Timer? _timer;
  String? _path;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<bool> _ensureMic() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mikrofon izni gerekli')),
    );
    return false;
  }

  Future<void> _start() async {
    if (!await _ensureMic()) return;
    if (!await _recorder.hasPermission()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon izni yok')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}${Platform.pathSeparator}ses_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      _recording = true;
      _elapsedSec = 0;
      _path = path;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSec++);
    });
  }

  Future<void> _stopAndSave() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() => _recording = false);

    final filePath = path ?? _path;
    if (filePath == null) return;

    final file = File(filePath);
    if (!await file.exists() || await file.length() == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt boş veya oluşturulamadı')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.db.createVoiceMemo(
        hastaId: widget.patient.id,
        file: file,
        sureSaniye: _elapsedSec,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ses kaydı yüklenemedi: $e')),
      );
    }
  }

  Future<void> _cancel() async {
    _timer?.cancel();
    if (_recording) {
      await _recorder.stop();
    }
    if (mounted) Navigator.pop(context, false);
  }

  String get _timeLabel {
    final m = _elapsedSec ~/ 60;
    final s = _elapsedSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Hızlı sesli not'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.patient.adSoyad,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            _timeLabel,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _recording
                ? 'Kayıt sürüyor…'
                : _saving
                    ? 'Yükleniyor…'
                    : 'Başlat’a basıp konuşun, bitince Kaydet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          if (!_saving)
            FilledButton.tonal(
              onPressed: _recording ? null : _start,
              style: FilledButton.styleFrom(
                minimumSize: const Size(88, 88),
                shape: const CircleBorder(),
                backgroundColor: _recording
                    ? scheme.errorContainer
                    : scheme.primaryContainer,
              ),
              child: Icon(
                _recording ? Icons.mic : Icons.mic_none,
                size: 36,
                color: _recording ? scheme.error : scheme.primary,
              ),
            ),
          if (_saving) const CircularProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : _cancel,
          child: const Text('İptal'),
        ),
        if (_recording)
          FilledButton.icon(
            onPressed: _stopAndSave,
            icon: const Icon(Icons.stop),
            label: const Text('Bitir & Kaydet'),
          ),
      ],
    );
  }
}
