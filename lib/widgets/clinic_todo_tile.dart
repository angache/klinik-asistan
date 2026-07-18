import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/clinic_todo.dart';
import '../services/database_service.dart';
import '../services/storage_media.dart';
import '../theme/app_theme.dart';

class ClinicTodoTile extends StatefulWidget {
  const ClinicTodoTile({
    super.key,
    required this.todo,
    required this.db,
    this.onChanged,
  });

  final ClinicTodo todo;
  final DatabaseService db;
  final Future<void> Function()? onChanged;

  @override
  State<ClinicTodoTile> createState() => _ClinicTodoTileState();
}

class _ClinicTodoTileState extends State<ClinicTodoTile> {
  final _player = AudioPlayer();
  bool _playing = false;
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
      '${dir.path}${Platform.pathSeparator}todo_cache_${widget.todo.id}.$safeExt',
    );

    if (await file.exists() && await file.length() > 0) return file;

    final bytes = await StorageMedia.downloadBytes(url);
    if (bytes.isEmpty) throw Exception('Ses dosyası boş');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _togglePlay() async {
    if (!widget.todo.hasVoice) return;
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
      return;
    }

    setState(() => _loadingAudio = true);
    try {
      final file = await _cacheRemoteAudio(widget.todo.sesUrl!);
      await _player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
      await _player.play(DeviceFileSource(file.path));
      setState(() => _playing = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ses çalınamadı: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingAudio = false);
    }
  }

  Future<void> _complete() async {
    try {
      await widget.db.completeClinicTodo(widget.todo.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tamamlandı')),
      );
      await widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem başarısız: $e')),
      );
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sil'),
        content: const Text('Bu yapılacak silinsin mi?'),
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
      await widget.db.deleteClinicTodo(widget.todo);
      if (!mounted) return;
      await widget.onChanged?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silinemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd.MM.yyyy');
    final todo = widget.todo;
    final accent = todo.isOverdue
        ? scheme.error
        : todo.isDueToday
            ? scheme.primary
            : scheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.hasVoice)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 2),
                    child: Icon(
                      Icons.mic,
                      size: 18,
                      color: AppTheme.voiceAccentDark,
                    ),
                  ),
                Expanded(
                  child: Text(
                    todo.displayText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (todo.planDateOnly != null)
                  Text(
                    fmt.format(todo.planDateOnly!),
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(todo.olusturmaTarihi),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (todo.hasVoice) ...[
                  const SizedBox(width: 8),
                  Text(
                    todo.durationLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (todo.hasVoice)
                  TextButton.icon(
                    onPressed: _loadingAudio ? null : _togglePlay,
                    icon: _loadingAudio
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_playing ? Icons.stop : Icons.play_arrow),
                    label: Text(_playing ? 'Durdur' : 'Dinle'),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Tamamla',
                  onPressed: _complete,
                  icon: const Icon(Icons.check_circle_outline),
                ),
                IconButton(
                  tooltip: 'Sil',
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
