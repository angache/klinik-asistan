import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Supabase Storage URL / path yardımcıları.
/// Bucket private; görüntüleme imzalı URL veya Storage download ile yapılır.
/// DB'de hem eski public URL hem ham object path tutulabilir.
class StorageMedia {
  StorageMedia._();

  static SupabaseClient get _client => Supabase.instance.client;
  static String get _bucket => SupabaseConfig.storageBucket;

  /// Kaydedilmiş public/sign URL veya ham object path'ten path çıkarır.
  static String? pathFromUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;

    // DB'de doğrudan object path tutuluyorsa
    if (!trimmed.contains('://') && !trimmed.startsWith('/')) {
      return trimmed;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;

    final segments = uri.pathSegments;
    // .../storage/v1/object/public/<bucket>/<path...>
    // .../storage/v1/object/sign/<bucket>/<path...>
    final objectIdx = segments.indexOf('object');
    if (objectIdx < 0 || objectIdx + 2 >= segments.length) return null;

    final bucketIdx = objectIdx + 2;
    if (segments[bucketIdx] != _bucket) {
      // Bazen bucket adı decode edilmiş olabilir
      if (Uri.decodeComponent(segments[bucketIdx]) != _bucket) return null;
    }

    final pathParts = segments.sublist(bucketIdx + 1);
    if (pathParts.isEmpty) return null;
    return pathParts.map(Uri.decodeComponent).join('/');
  }

  /// Görüntüleme / oynatma için imzalı URL (1 saat).
  static Future<String> signedUrl(String storedUrl, {int expiresIn = 3600}) async {
    final path = pathFromUrl(storedUrl);
    if (path == null || path.isEmpty) return storedUrl;

    try {
      return await _client.storage.from(_bucket).createSignedUrl(path, expiresIn);
    } catch (_) {
      // Path yanlışsa veya politika yoksa orijinal URL'ye düş
      return storedUrl;
    }
  }

  /// Dosya baytlarını Storage API ile indirir (http public URL'ye bağlı değil).
  static Future<Uint8List> downloadBytes(String storedUrl) async {
    final path = pathFromUrl(storedUrl);
    if (path == null || path.isEmpty) {
      throw Exception('Geçersiz dosya yolu');
    }
    return await _client.storage.from(_bucket).download(path);
  }
}
