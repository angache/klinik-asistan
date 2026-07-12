import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/storage_media.dart';

/// Diyalog içi yerel fotoğraf önizlemesi.
class LocalPhotoPreview extends StatelessWidget {
  const LocalPhotoPreview({
    super.key,
    required this.file,
    required this.onRemove,
  });

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            file,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: onRemove,
              tooltip: 'Fotoğrafı kaldır',
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
