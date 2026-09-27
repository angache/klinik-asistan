import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'storage_media.dart';

/// Seans fotoğraflarını sistem paylaşım menüsüyle (WhatsApp, e-posta…) gönderir.
class PhotoShare {
  PhotoShare._();

  static Future<void> share(
    BuildContext context,
    List<String> urls, {
    String? text,
  }) async {
    if (urls.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          urls.length > 1
              ? '${urls.length} fotoğraf hazırlanıyor…'
              : 'Fotoğraf hazırlanıyor…',
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      final dir = await Directory(
        '${(await getTemporaryDirectory()).path}/paylasim',
      ).create(recursive: true);
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final files = <XFile>[];
      for (var i = 0; i < urls.length; i++) {
        final bytes = await StorageMedia.downloadBytes(urls[i]);
        final ext = _extension(urls[i]);
        final file = File('${dir.path}/islem_${stamp}_${i + 1}.$ext');
        await file.writeAsBytes(bytes, flush: true);
        files.add(XFile(file.path, mimeType: 'image/$ext'));
      }
      messenger.hideCurrentSnackBar();

      final caption = text?.trim();
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: caption == null || caption.isEmpty ? null : caption,
          subject: caption == null || caption.isEmpty ? null : caption,
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Paylaşılamadı: $e')));
    }
  }

  static String _extension(String url) {
    final path = StorageMedia.pathFromUrl(url) ?? url;
    final ext = path.split('.').last.toLowerCase();
    return switch (ext) {
      'png' || 'webp' => ext,
      _ => 'jpeg',
    };
  }
}
