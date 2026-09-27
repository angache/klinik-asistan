import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/clinic_todo.dart';
import '../services/database_service.dart';
import '../services/storage_media.dart';

class ClinicTodoDetailScreen extends StatefulWidget {
  const ClinicTodoDetailScreen({
    super.key,
    required this.db,
    required this.todoId,
  });

  final DatabaseService db;
  final String todoId;

  @override
  State<ClinicTodoDetailScreen> createState() => _ClinicTodoDetailScreenState();
}

class _ClinicTodoDetailScreenState extends State<ClinicTodoDetailScreen> {
  final _comment = TextEditingController();
  final _picker = ImagePicker();
  bool _loading = true;
  bool _busy = false;
  bool _changed = false;
  Object? _error;
  ClinicTodo? _todo;
  List<TodoImage> _images = const [];
  List<TodoComment> _comments = const [];
  List<TodoEvent> _history = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final results = await Future.wait<Object>([
        widget.db.getClinicTodo(widget.todoId),
        widget.db.getClinicTodoImages(widget.todoId),
        widget.db.getClinicTodoComments(widget.todoId),
        widget.db.getClinicTodoHistory(widget.todoId),
      ]);
      if (!mounted) return;
      setState(() {
        _todo = results[0] as ClinicTodo;
        _images = results[1] as List<TodoImage>;
        _comments = results[2] as List<TodoComment>;
        _history = results[3] as List<TodoEvent>;
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

  Future<void> _addComment() async {
    final text = _comment.text.trim();
    if (text.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.db.addClinicTodoComment(todoId: widget.todoId, text: text);
      _comment.clear();
      _changed = true;
      await _load();
    } catch (e) {
      _showError('Yorum eklenemedi: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addImages() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final files = <XFile>[];
      if (source == ImageSource.camera) {
        final cam = await Permission.camera.request();
        if (!cam.isGranted) {
          _showError('Kamera izni gerekli');
          return;
        }
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 82,
          maxWidth: 1800,
        );
        if (image != null) files.add(image);
      } else {
        files.addAll(
          await _picker.pickMultiImage(
            imageQuality: 82,
            maxWidth: 1800,
          ),
        );
      }
      if (files.isEmpty || !mounted) return;

      setState(() => _busy = true);
      for (final image in files) {
        await widget.db.addClinicTodoImage(
          todoId: widget.todoId,
          file: File(image.path),
        );
      }
      _changed = true;
      await _load();
    } catch (e) {
      _showError(
        source == ImageSource.camera
            ? 'Kamera açılamadı: $e'
            : 'Görsel eklenemedi: $e',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete() async {
    final todo = _todo;
    if (todo == null || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.db.completeClinicTodo(todo);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showError('Tamamlanamadı: $e');
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openImage(TodoImage image) async {
    try {
      final bytes = await StorageMedia.downloadBytes(image.path);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => Dialog.fullscreen(
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Center(child: Image.memory(bytes)),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: SafeArea(
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      _showError('Görsel açılamadı: $e');
    }
  }

  Future<void> _deleteImage(TodoImage image) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Görseli sil'),
        content: const Text('Bu görsel görevden kaldırılsın mı?'),
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
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.db.deleteClinicTodoImage(image);
      _changed = true;
      await _load();
    } catch (e) {
      _showError('Görsel silinemedi: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacak ayrıntısı'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _changed),
        ),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _body(),
      bottomNavigationBar: _todo == null || _todo!.tamamlandi
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: _busy ? null : _complete,
                  icon: const Icon(Icons.check),
                  label: const Text('Tamamlandı olarak işaretle'),
                ),
              ),
            ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Yüklenemedi: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: const Text('Tekrar dene')),
            ],
          ),
        ),
      );
    }

    final todo = _todo!;
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Text(
          todo.displayText,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _infoChip(
              Icons.flag_outlined,
              todo.oncelik.label,
              todo.oncelik == TodoPriority.urgent ? scheme.error : null,
            ),
            _infoChip(Icons.event_outlined, todo.scheduleLabel),
            _infoChip(
              Icons.person_outline,
              todo.sorumluAdSoyad ?? 'Tüm klinik',
            ),
            if (todo.hastaAdSoyad != null)
              _infoChip(Icons.badge_outlined, todo.hastaAdSoyad!),
            if (todo.tekrar != TodoRecurrence.none)
              _infoChip(Icons.repeat, todo.tekrar.label),
            if (todo.hasVoice)
              _infoChip(Icons.mic_outlined, todo.durationLabel),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${todo.olusturanAdSoyad ?? 'Klinik üyesi'} tarafından '
          '${DateFormat('dd.MM.yyyy HH:mm').format(todo.olusturmaTarihi)} tarihinde oluşturuldu',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const Divider(height: 32),
        _sectionHeader(
          'Görseller',
          action: TextButton.icon(
            onPressed: _busy ? null : _addImages,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Ekle'),
          ),
        ),
        if (_images.isEmpty)
          const Text('Görsel eklenmemiş')
        else
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => _RemoteTodoImage(
                image: _images[index],
                onTap: () => _openImage(_images[index]),
                onDelete: _busy ? null : () => _deleteImage(_images[index]),
              ),
            ),
          ),
        const Divider(height: 32),
        _sectionHeader('Yorumlar (${_comments.length})'),
        if (_comments.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Henüz yorum yok'),
          ),
        ..._comments.map(
          (c) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person, size: 18)),
            title: Text(c.authorName),
            subtitle: Text(c.text),
            trailing: Text(
              DateFormat('dd.MM HH:mm').format(c.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _comment,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Yorum ekle…',
                ),
              ),
            ),
            IconButton.filled(
              onPressed: _busy ? null : _addComment,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        const Divider(height: 32),
        _sectionHeader('Geçmiş'),
        if (_history.isEmpty)
          const Text('Geçmiş kaydı yok')
        else
          ..._history.map(
            (e) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_eventIcon(e.type), size: 20),
              title: Text(_eventLabel(e.type)),
              subtitle: Text(
                '${e.actorName} · '
                '${DateFormat('dd.MM.yyyy HH:mm').format(e.createdAt)}',
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionHeader(String title, {Widget? action}) => Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          if (action != null) action,
        ],
      );

  Widget _infoChip(IconData icon, String label, [Color? color]) => Chip(
        avatar: Icon(icon, size: 16, color: color),
        label: Text(label),
      );

  IconData _eventIcon(String type) => switch (type) {
        'olusturuldu' => Icons.add_circle_outline,
        'tamamlandi' => Icons.check_circle_outline,
        'yorum_eklendi' => Icons.comment_outlined,
        'gorsel_eklendi' => Icons.add_photo_alternate_outlined,
        'gorsel_silindi' => Icons.hide_image_outlined,
        _ => Icons.history,
      };

  String _eventLabel(String type) => switch (type) {
        'olusturuldu' => 'Görev oluşturuldu',
        'tamamlandi' => 'Görev tamamlandı',
        'yorum_eklendi' => 'Yorum eklendi',
        'gorsel_eklendi' => 'Görsel eklendi',
        'gorsel_silindi' => 'Görsel silindi',
        _ => type,
      };
}

class _RemoteTodoImage extends StatefulWidget {
  const _RemoteTodoImage({
    required this.image,
    required this.onTap,
    this.onDelete,
  });

  final TodoImage image;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  State<_RemoteTodoImage> createState() => _RemoteTodoImageState();
}

class _RemoteTodoImageState extends State<_RemoteTodoImage> {
  late final Future<Uint8List> _bytes =
      StorageMedia.downloadBytes(widget.image.path);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 112,
              height: 112,
              child: FutureBuilder<Uint8List>(
                future: _bytes,
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Image.memory(snap.data!, fit: BoxFit.cover);
                  }
                  if (snap.hasError) {
                    return const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.broken_image_outlined),
                    );
                  }
                  return const ColoredBox(
                    color: Colors.black12,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: 3,
          top: 3,
          child: IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            onPressed: widget.onDelete,
            icon: const Icon(Icons.delete_outline, size: 17),
          ),
        ),
      ],
    );
  }
}
