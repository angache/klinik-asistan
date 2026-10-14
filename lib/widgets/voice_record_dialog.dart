import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../l10n/l10n.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

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
      SnackBar(content: Text(context.l10n.micPermissionRequired)),
    );
    return false;
  }

  Future<void> _start() async {
    if (!await _ensureMic()) return;
    if (!await _recorder.hasPermission()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.micPermissionMissing)),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    // WAV: Android MediaPlayer'da m4a/URL sorunlarını azaltır
    final path =
        '${dir.path}${Platform.pathSeparator}ses_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        numChannels: 1,
        sampleRate: 16000,
        bitRate: 256000,
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
        SnackBar(content: Text(context.l10n.recordingEmpty)),
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
        SnackBar(content: Text(context.l10n.voiceUploadFailed('$e'))),
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
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.quickVoiceNote),
      content: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.patient.adSoyad,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.voicePrivacyHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
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
                    ? l10n.recordingInProgress
                    : _saving
                        ? l10n.uploadingVoice
                        : l10n.voiceStartHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: (_recording || _saving) ? null : _start,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(88, 88),
                  shape: const CircleBorder(),
                  backgroundColor: _recording
                      ? scheme.errorContainer
                      : AppTheme.voiceAccent.withValues(alpha: 0.2),
                ),
                child: Icon(
                  _recording ? Icons.mic : Icons.mic_none,
                  size: 36,
                  color: _recording ? scheme.error : AppTheme.voiceAccentDark,
                ),
              ),
            ],
          ),
          if (_saving)
            Positioned.fill(
              child: ColoredBox(
                color: scheme.surface.withValues(alpha: 0.85),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.uploadingVoice,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.pleaseWait),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : _cancel,
          child: Text(l10n.cancel),
        ),
        if (_recording)
          FilledButton.icon(
            onPressed: _stopAndSave,
            icon: const Icon(Icons.stop),
            label: Text(l10n.finishAndSave),
          ),
      ],
    );
  }
}
