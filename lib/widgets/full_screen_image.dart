import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/storage_media.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({super.key, required this.imageUrl});

  final String imageUrl;

  static Future<void> open(BuildContext context, String imageUrl) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenImage(imageUrl: imageUrl),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = StorageMedia.downloadBytes(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Seans Fotoğrafı'),
      ),
      body: Center(
        child: FutureBuilder<Uint8List>(
          future: _bytes,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator(color: Colors.white);
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image, color: Colors.white54, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Fotoğraf yüklenemedi\n${snapshot.error ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              );
            }
            return InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Image.memory(snapshot.data!, fit: BoxFit.contain),
            );
          },
        ),
      ),
    );
  }
}
