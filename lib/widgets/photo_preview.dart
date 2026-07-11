import 'dart:io';

import 'package:flutter/material.dart';

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

/// Not listesinde küçük ağ fotoğrafı önizlemesi.
class NetworkPhotoThumbnail extends StatelessWidget {
  const NetworkPhotoThumbnail({
    super.key,
    required this.url,
    this.onTap,
  });

  final String url;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          height: 72,
          width: 96,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 72,
            width: 96,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
