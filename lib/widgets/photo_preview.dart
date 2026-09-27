import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/storage_media.dart';
import 'full_screen_image.dart';

const int kMaxSessionPhotos = 10;

/// Seans kartlarında fotoğrafları yan yana gösterir; dokununca galeri açılır.
class NetworkPhotoStrip extends StatelessWidget {
  const NetworkPhotoStrip({super.key, required this.urls, this.shareText});

  final List<String> urls;
  final String? shareText;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < urls.length; i++)
          NetworkPhotoThumbnail(
            url: urls[i],
            onTap: () => FullScreenImage.openGallery(
              context,
              urls,
              initialIndex: i,
              shareText: shareText,
            ),
          ),
      ],
    );
  }
}

/// Yeni / düzenle formlarında çoklu fotoğraf seçimi.
class SessionPhotosEditor extends StatelessWidget {
  const SessionPhotosEditor({
    super.key,
    required this.existingUrls,
    required this.newFiles,
    required this.onAddFiles,
    required this.onRemoveExisting,
    required this.onRemoveNew,
    this.enabled = true,
  });

  final List<String> existingUrls;
  final List<File> newFiles;
  final ValueChanged<List<File>> onAddFiles;
  final ValueChanged<String> onRemoveExisting;
  final ValueChanged<File> onRemoveNew;
  final bool enabled;

  int get _count => existingUrls.length + newFiles.length;
  int get _remaining => kMaxSessionPhotos - _count;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final remaining = _remaining;
    if (remaining <= 0) return;
    final picker = ImagePicker();
    try {
      final List<XFile> picked;
      if (source == ImageSource.camera || remaining == 1) {
        final x = await picker.pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 1920,
        );
        picked = x == null ? const [] : [x];
      } else {
        picked = await picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1920,
          limit: remaining,
        );
      }
      if (picked.isEmpty) return;
      onAddFiles(picked.take(remaining).map((x) => File(x.path)).toList());
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf açılamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_count > 0) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < existingUrls.length; i++)
                _RemovableThumb(
                  onRemove:
                      enabled ? () => onRemoveExisting(existingUrls[i]) : null,
                  child: NetworkPhotoThumbnail(
                    url: existingUrls[i],
                    onTap: () => FullScreenImage.openGallery(
                      context,
                      existingUrls,
                      initialIndex: i,
                    ),
                  ),
                ),
              for (final file in newFiles)
                _RemovableThumb(
                  onRemove: enabled ? () => onRemoveNew(file) : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      file,
                      height: 72,
                      width: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$_count / $kMaxSessionPhotos fotoğraf',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
        ],
        if (_remaining > 0)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      enabled ? () => _pick(context, ImageSource.camera) : null,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Fotoğraf Çek'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: enabled
                      ? () => _pick(context, ImageSource.gallery)
                      : null,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeriden'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _RemovableThumb extends StatelessWidget {
  const _RemovableThumb({required this.child, this.onRemove});

  final Widget child;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (onRemove != null)
          Positioned(
            top: 2,
            right: 2,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Storage'dan imzalı URL / byte ile çalışan ağ fotoğrafı.
class NetworkPhotoThumbnail extends StatefulWidget {
  const NetworkPhotoThumbnail({
    super.key,
    required this.url,
    this.onTap,
  });

  final String url;
  final VoidCallback? onTap;

  @override
  State<NetworkPhotoThumbnail> createState() => _NetworkPhotoThumbnailState();
}

class _NetworkPhotoThumbnailState extends State<NetworkPhotoThumbnail> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = StorageMedia.downloadBytes(widget.url);
  }

  @override
  void didUpdateWidget(covariant NetworkPhotoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _bytes = StorageMedia.downloadBytes(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder<Uint8List>(
          future: _bytes,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                height: 72,
                width: 96,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Container(
                height: 72,
                width: 96,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              );
            }
            return Image.memory(
              snapshot.data!,
              height: 72,
              width: 96,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
