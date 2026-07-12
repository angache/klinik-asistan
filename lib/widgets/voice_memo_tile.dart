import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/patient.dart';
import '../models/voice_memo.dart';
import '../services/database_service.dart';
import '../services/storage_media.dart';
import '../theme/app_theme.dart';
import 'new_session_dialog.dart';

class VoiceMemoTile extends StatefulWidget {
  const VoiceMemoTile({
    super.key,
    required this.memo,
    required this.patient,
    required this.db,
    this.onChanged,
  });

  final VoiceMemo memo;
  final Patient patient;
  final DatabaseService db;
  final Future<void> Function()? onChanged;

  @override
  State<VoiceMemoTile> createState() => _VoiceMemoTileState();
}

class _VoiceMemoTileState extends State<VoiceMemoTile> {
  final _player = AudioPlayer();
  bool _playing = false;
  bool _busy = false;
  bool _loadingAudio = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        setState(() => _playing = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<File> _cacheRemoteAudio(String url) async {
    final path = StorageMedia.pathFromUrl(url);
    final ext = (path ?? url).split('.').last.toLowerCase();
    final safeExt = (ext.length <= 4 && ext.isNotEmpty) ? ext : 'wav';
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}${Platform.pathSeparator}voice_cache_${widget.memo.id}.$safeExt',
    );

    if (await file.exists() && await file.length() > 0) {
      return file;
    }

    final bytes = await StorageMedia.downloadBytes(url);
    if (bytes.isEmpty) {
      throw Exception('Ses dosyası boş');
    }
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
      return;
    }

    setState(() => _loadingAudio = true);
    try {
      // Uzaktan URL yerine yerel dosya — Android MEDIA_ERROR_UNKNOWN azaltır
      final file = await _cacheRemoteAudio(widget.memo.dosyaUrl);

      await _player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
          ),
        ),
      );
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.play(
        DeviceFileSource(file.path),
        mode: PlayerMode.mediaPlayer,
      );

      if (!mounted) return;
      setState(() {
        _playing = true;
        _loadingAudio = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _playing = false;
        _loadingAudio = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çalınamadı: $e')),
      );
    }
  }

  Future<void> _convertToNote() async {
    await _player.stop();
    setState(() => _playing = false);
    if (!mounted) return;

    final saved = await showNewSessionDialog(
      context: context,
      patient: widget.patient,
      db: widget.db,
    );
    if (saved == null || !mounted) return;

    setState(() => _busy = true);
    try {
      await widget.db.markVoiceMemoProcessed(
        memoId: widget.memo.id,
        seansNotuId: saved.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesli not işlendi olarak işaretlendi')),
      );
      await widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşaretlenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sesli notu sil'),
        content: const Text('Bu sesli not kalıcı olarak silinecek.'),
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
    setState(() => _busy = true);
    try {
      await widget.db.deleteVoiceMemo(widget.memo);
      await widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silinemedi: $e')),
      );
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final memo = widget.memo;
    final dt =
        DateFormat('dd.MM.yyyy HH:mm').format(memo.olusturmaTarihi.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: memo.islenen
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : AppTheme.voiceAccent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: memo.islenen ? scheme.outlineVariant : AppTheme.voiceAccent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic,
                size: 18,
                color: memo.islenen
                    ? scheme.onSurfaceVariant
                    : AppTheme.voiceAccentDark,
              ),
              const SizedBox(width: 6),
              Text(
                memo.islenen ? 'İşlenmiş sesli not' : 'Bekleyen sesli not',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: memo.islenen
                      ? scheme.onSurfaceVariant
                      : AppTheme.voiceAccentDark,
                ),
              ),
              const Spacer(),
              Text(
                dt,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Süre: ${memo.durationLabel}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: (_busy || _loadingAudio) ? null : _togglePlay,
                icon: _loadingAudio
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_playing ? Icons.stop : Icons.play_arrow),
                tooltip: _playing ? 'Durdur' : 'Dinle',
              ),
              if (!memo.islenen)
                TextButton.icon(
                  onPressed: _busy ? null : _convertToNote,
                  icon: const Icon(Icons.note_alt_outlined, size: 18),
                  label: const Text('Nota dönüştür'),
                ),
              const Spacer(),
              IconButton(
                onPressed: _busy ? null : _delete,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Sil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
