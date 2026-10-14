import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../l10n/l10n.dart';

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
  static Future<String> signedUrl(String storedUrl,
      {int expiresIn = 3600}) async {
    final path = pathFromUrl(storedUrl);
    if (path == null || path.isEmpty) return storedUrl;

    try {
      return await _client.storage
          .from(_bucket)
          .createSignedUrl(path, expiresIn);
    } catch (_) {
      // Path yanlışsa veya politika yoksa orijinal URL'ye düş
      return storedUrl;
    }
  }

  static const _thumbSuffix = '_kucuk';
  static final _imagePath =
      RegExp(r'^(.*)\.(jpe?g|png|webp)$', caseSensitive: false);

  /// Yüklemede asıl fotoğrafın yanına konan küçük kopyanın yolu.
  static String? thumbnailPathFor(String path) {
    final m = _imagePath.firstMatch(path);
    if (m == null || m.group(1)!.endsWith(_thumbSuffix)) return null;
    return '${m.group(1)}$_thumbSuffix.jpg';
  }

  static const _cacheMaxBytes = 60 * 1024 * 1024;
  static const _diskMaxBytes = 300 * 1024 * 1024;
  static final _cache = <String, Uint8List>{}; // ekleme sırası = LRU sırası
  static final _inFlight = <String, Future<Uint8List>>{};
  static final _missingThumbs = <String>{};
  static int _cacheBytes = 0;
  static Future<Directory?>? _diskDir;

  /// Dosya baytlarını Storage API ile indirir (http public URL'ye bağlı değil).
  /// Dosyalar değişmez (her yükleme yeni uuid); bellekte ve diskte tutulur.
  static Future<Uint8List> downloadBytes(String storedUrl) {
    final path = pathFromUrl(storedUrl);
    if (path == null || path.isEmpty) {
      return Future.error(Exception(currentL10n.errInvalidFilePath));
    }
    return _load(path);
  }

  /// Liste küçük resmi: küçük kopya varsa o, yoksa (eski kayıtlar) asıl dosya.
  static Future<Uint8List> thumbnailBytes(String storedUrl) async {
    final path = pathFromUrl(storedUrl);
    if (path == null || path.isEmpty) {
      throw Exception(currentL10n.errInvalidFilePath);
    }
    final thumb = thumbnailPathFor(path);
    if (thumb != null && !_missingThumbs.contains(path)) {
      final hit = await _cached(thumb) ?? await _cached(path);
      if (hit != null) return hit;
      try {
        return await _load(thumb, logErrors: false);
      } on StorageException {
        _missingThumbs.add(path);
      }
    }
    return _load(path);
  }

  /// Bellekteki küçük resim (tam ekran açılırken yer tutucu olarak).
  static Uint8List? peekThumbnail(String storedUrl) {
    final path = pathFromUrl(storedUrl);
    if (path == null) return null;
    final thumb = thumbnailPathFor(path);
    return (thumb == null ? null : _cache[thumb]) ?? _cache[path];
  }

  /// Az önce yüklenen dosyayı tekrar indirmemek için önbelleğe koyar.
  static void prime(String path, Uint8List bytes) {
    _remember(path, bytes);
    unawaited(_writeDisk(path, bytes));
  }

  /// Çıkışta hasta görsellerini cihazda bırakmamak için.
  static Future<void> clearCache() async {
    _cache.clear();
    _cacheBytes = 0;
    _missingThumbs.clear();
    final dir = await (_diskDir ?? Future.value(null));
    _diskDir = null;
    try {
      if (dir != null && await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  }

  static Future<Uint8List?> _cached(String path) async {
    final mem = _cache.remove(path);
    if (mem != null) {
      _cache[path] = mem;
      return mem;
    }
    final disk = await _readDisk(path);
    if (disk != null) _remember(path, disk);
    return disk;
  }

  static Future<Uint8List> _load(String path, {bool logErrors = true}) async {
    final hit = await _cached(path);
    if (hit != null) return hit;
    return _inFlight[path] ??=
        _fetch(path, logErrors).whenComplete(() => _inFlight.remove(path));
  }

  static Future<Uint8List> _fetch(String path, bool logErrors) async {
    try {
      final bytes = await _client.storage
          .from(_bucket)
          .download(path)
          .timeout(const Duration(seconds: 45));
      prime(path, bytes);
      return bytes;
    } catch (e) {
      if (logErrors) debugPrint('StorageMedia indirme hatası ($path): $e');
      rethrow;
    }
  }

  static Future<Directory?> _dir() => _diskDir ??= _openDisk();

  static Future<Directory?> _openDisk() async {
    if (kIsWeb) return null;
    try {
      final base = await getApplicationCacheDirectory();
      final dir = Directory('${base.path}${Platform.pathSeparator}medya');
      await dir.create(recursive: true);
      unawaited(_prune(dir));
      return dir;
    } catch (_) {
      return null;
    }
  }

  static File _file(Directory dir, String path) => File(
        '${dir.path}${Platform.pathSeparator}'
        '${path.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')}',
      );

  static Future<Uint8List?> _readDisk(String path) async {
    try {
      final dir = await _dir();
      if (dir == null) return null;
      final f = _file(dir, path);
      return await f.exists() ? await f.readAsBytes() : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _writeDisk(String path, Uint8List bytes) async {
    try {
      final dir = await _dir();
      if (dir == null) return;
      final f = _file(dir, path);
      final tmp = File('${f.path}.tmp');
      await tmp.writeAsBytes(bytes, flush: true);
      await tmp.rename(f.path);
    } catch (_) {}
  }

  static Future<void> _prune(Directory dir) async {
    try {
      final files =
          await dir.list().where((e) => e is File).cast<File>().toList();
      final stats = [for (final f in files) (f, await f.stat())];
      var total = stats.fold<int>(0, (s, e) => s + e.$2.size);
      if (total <= _diskMaxBytes) return;
      stats.sort((a, b) => a.$2.modified.compareTo(b.$2.modified));
      for (final (f, stat) in stats) {
        if (total <= _diskMaxBytes * 0.8) break;
        await f.delete();
        total -= stat.size;
      }
    } catch (_) {}
  }

  static void _remember(String path, Uint8List bytes) {
    if (bytes.lengthInBytes > _cacheMaxBytes ~/ 4) return;
    final old = _cache.remove(path);
    if (old != null) _cacheBytes -= old.lengthInBytes;
    _cache[path] = bytes;
    _cacheBytes += bytes.lengthInBytes;
    while (_cacheBytes > _cacheMaxBytes && _cache.isNotEmpty) {
      final oldest = _cache.keys.first;
      _cacheBytes -= _cache.remove(oldest)!.lengthInBytes;
    }
  }
}
