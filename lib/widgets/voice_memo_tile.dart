import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/patient.dart';
import '../models/voice_memo.dart';
import '../services/database_service.dart';
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

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
      return;
    }
    try {
      await _player.play(UrlSource(widget.memo.dosyaUrl));
      setState(() => _playing = true);
    } catch (e) {
      if (!mounted) return;
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
    if (saved != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await widget.db.markVoiceMemoProcessed(memoId: widget.memo.id);
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
            : scheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: memo.islenen ? scheme.outlineVariant : scheme.tertiary,
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
                color: memo.islenen ? scheme.onSurfaceVariant : scheme.tertiary,
              ),
              const SizedBox(width: 6),
              Text(
                memo.islenen ? 'İşlenmiş sesli not' : 'Bekleyen sesli not',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: memo.islenen
                      ? scheme.onSurfaceVariant
                      : scheme.onTertiaryContainer,
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
                onPressed: _busy ? null : _togglePlay,
                icon: Icon(_playing ? Icons.stop : Icons.play_arrow),
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
