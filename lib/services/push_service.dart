import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../firebase_options.dart';
import 'notification_service.dart';

/// Arka plan FCM mesajı (top-level olmalı).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

/// FCM push: token kaydı + izin (Android / iOS / web).
/// Windows/macOS/Linux: destek yok — sessizce atlanır.
class PushService {
  PushService._();
  static final instance = PushService._();

  bool _ready = false;
  String? _token;

  bool get isSupported {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  String get _platformLabel {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 'ios',
      TargetPlatform.android => 'android',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      _ => 'web',
    };
  }

  Future<void> init() async {
    if (!isSupported) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      messaging.onTokenRefresh.listen(_persistToken);

      _ready = true;
      await syncToken();
    } catch (e) {
      debugPrint('PushService.init hata: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ??
        message.data['title'] as String? ??
        'Klinik Asistan';
    final body = message.notification?.body ??
        message.data['body'] as String? ??
        '';
    NotificationService.instance.showImmediate(
      title: title,
      body: body,
    );
  }

  /// Giriş sonrası veya klinik değişince token'ı kaydet.
  Future<void> syncToken() async {
    if (!_ready || !isSupported) return;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      _token = token;
      await _persistToken(token);
    } catch (e) {
      debugPrint('PushService.syncToken hata: $e');
    }
  }

  Future<void> _persistToken(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client.from('device_tokens').upsert(
        {
          'user_id': user.id,
          'token': token,
          'platform': _platformLabel,
          'guncelleme_tarihi': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'token',
      );
      _token = token;
    } catch (e) {
      debugPrint('PushService._persistToken hata: $e');
    }
  }

  /// Çıkışta token'ı sil (başka cihazlara karışmasın).
  Future<void> clearToken() async {
    if (!_ready || !isSupported) return;
    final token = _token;
    try {
      if (token != null && token.isNotEmpty) {
        await Supabase.instance.client
            .from('device_tokens')
            .delete()
            .eq('token', token);
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
    _token = null;
  }
}
