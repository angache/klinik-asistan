import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/l10n.dart';
import '../models/clinic_todo.dart';
import '../services/database_service.dart';
import '../services/storage_media.dart';
import '../widgets/photo_preview.dart' show kPhotoMaxSide, kPhotoQuality;

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
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      await widget.db.addClinicTodoComment(todoId: widget.todoId, text: text);
      _comment.clear();
      _changed = true;
      await _load();
    } catch (e) {
      _showError(l10n.commentAddFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addImages() async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.gallery),
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
          _showError(l10n.cameraPermissionRequired);
          return;
        }
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: kPhotoQuality,
          maxWidth: kPhotoMaxSide,
          maxHeight: kPhotoMaxSide,
        );
        if (image != null) files.add(image);
      } else {
        files.addAll(
          await _picker.pickMultiImage(
            imageQuality: kPhotoQuality,
            maxWidth: kPhotoMaxSide,
            maxHeight: kPhotoMaxSide,
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
            ? l10n.cameraOpenFailed('$e')
            : l10n.imageAddFailed('$e'),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete() async {
    final todo = _todo;
    if (todo == null || _busy) return;
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      await widget.db.completeClinicTodo(todo);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showError(l10n.completeFailed('$e'));
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
    final l10n = context.l10n;
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
      _showError(l10n.imageOpenFailed('$e'));
    }
  }

  Future<void> _deleteImage(TodoImage image) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteImageTitle),
        content: Text(l10n.deleteImageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
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
      _showError(l10n.imageDeleteFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todoDetailTitle),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _changed),
        ),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
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
                  label: Text(l10n.markAsCompleted),
                ),
              ),
            ),
    );
  }

  Widget _body() {
    final l10n = context.l10n;
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
              Text(l10n.loadFailed('$_error'), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: Text(l10n.retry)),
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
              todo.sorumluAdSoyad ?? l10n.wholeClinic,
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
          l10n.createdByOn(
            todo.olusturanAdSoyad ?? l10n.clinicMemberFallback,
            DateFormat.yMd().add_Hm().format(todo.olusturmaTarihi),
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const Divider(height: 32),
        _sectionHeader(
          l10n.images,
          action: TextButton.icon(
            onPressed: _busy ? null : _addImages,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(l10n.add),
          ),
        ),
        if (_images.isEmpty)
          Text(l10n.noImages)
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
        _sectionHeader(l10n.commentsCount(_comments.length)),
        if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l10n.noCommentsYet),
          ),
        ..._comments.map(
          (c) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person, size: 18)),
            title: Text(c.authorName),
            subtitle: Text(c.text),
            trailing: Text(
              DateFormat.Md().add_Hm().format(c.createdAt),
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
                decoration: InputDecoration(
                  hintText: l10n.addCommentHint,
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
        _sectionHeader(l10n.history),
        if (_history.isEmpty)
          Text(l10n.noHistory)
        else
          ..._history.map(
            (e) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_eventIcon(e.type), size: 20),
              title: Text(_eventLabel(e.type)),
              subtitle: Text(
                '${e.actorName} · '
                '${DateFormat.yMd().add_Hm().format(e.createdAt)}',
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
        'olusturuldu' => context.l10n.eventCreated,
        'tamamlandi' => context.l10n.eventCompleted,
        'yorum_eklendi' => context.l10n.eventCommentAdded,
        'gorsel_eklendi' => context.l10n.eventImageAdded,
        'gorsel_silindi' => context.l10n.eventImageDeleted,
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
