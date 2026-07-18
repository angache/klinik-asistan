import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/follow_up.dart';

/// Yerel takip bildirimleri (Android / iOS). Windows'ta no-op.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    _ready = true;
  }

  int _notifId(String followUpId) => followUpId.hashCode & 0x7fffffff;

  Future<void> scheduleFollowUp(FollowUp f) async {
    if (!_ready || f.tamamlandi) return;

    final when = tz.TZDateTime(
      tz.local,
      f.reminderDateOnly.year,
      f.reminderDateOnly.month,
      f.reminderDateOnly.day,
      9,
    );
    final date = '${f.planDateOnly.day.toString().padLeft(2, '0')}.'
        '${f.planDateOnly.month.toString().padLeft(2, '0')}.'
        '${f.planDateOnly.year}';
    final body =
        f.hatirlatmaGunOnce > 0 ? '${f.baslik} · Kontrol: $date' : f.baslik;
    if (when.isBefore(tz.TZDateTime.now(tz.local))) {
      // Gecikmiş / bugün: hemen bir bilgi bildirimi
      await _plugin.show(
        id: _notifId(f.id),
        title: 'Takip: ${f.hastaAdSoyad ?? 'Hasta'}',
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'takipler',
            'Takipler',
            channelDescription: 'Kontrol ve takip hatırlatmaları',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      return;
    }

    await _plugin.zonedSchedule(
      id: _notifId(f.id),
      title: 'Takip: ${f.hastaAdSoyad ?? 'Hasta'}',
      body: body,
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'takipler',
          'Takipler',
          channelDescription: 'Kontrol ve takip hatırlatmaları',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelFollowUp(String id) async {
    if (!_ready) return;
    await _plugin.cancel(id: _notifId(id));
  }

  Future<void> syncOpenFollowUps(List<FollowUp> items) async {
    if (!_ready) return;
    for (final f in items) {
      await scheduleFollowUp(f);
    }
  }
}
