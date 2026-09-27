import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/photo_share.dart';
import '../services/storage_media.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.shareText,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String? shareText;

  static Future<void> open(BuildContext context, String imageUrl) {
    return openGallery(context, [imageUrl]);
  }

  static Future<void> openGallery(
    BuildContext context,
    List<String> imageUrls, {
    int initialIndex = 0,
    String? shareText,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenImage(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          shareText: shareText,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _share(BuildContext buttonContext) async {
    final urls = widget.imageUrls;
    var selected = [urls[_index]];
    if (urls.length > 1) {
      final all = await showModalBottomSheet<bool>(
        context: context,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('Bu fotoğrafı paylaş'),
                onTap: () => Navigator.pop(ctx, false),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('Tüm fotoğrafları paylaş (${urls.length})'),
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        ),
      );
      if (all == null) return;
      if (all) selected = urls;
    }
    if (!buttonContext.mounted) return;
    await PhotoShare.share(buttonContext, selected, text: widget.shareText);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.imageUrls.length;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          count > 1
              ? 'İşlem Fotoğrafı ${_index + 1}/$count'
              : 'İşlem Fotoğrafı',
        ),
        actions: [
          Builder(
            builder: (btnContext) => IconButton(
              tooltip: 'Paylaş (WhatsApp, e-posta…)',
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _share(btnContext),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: count,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) => _GalleryPage(url: widget.imageUrls[i]),
      ),
    );
  }
}

class _GalleryPage extends StatefulWidget {
  const _GalleryPage({required this.url});

  final String url;

  @override
  State<_GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<_GalleryPage> {
  late final Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = StorageMedia.downloadBytes(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
