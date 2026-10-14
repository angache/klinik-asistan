import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/l10n.dart';
import '../models/follow_up.dart';

/// Yerel takip bildirimleri (Android / iOS). Windows'ta no-op.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Cihaz push token'ı sunucuya kayıtlıysa günlük hatırlatmaları sunucu
  /// (daily-reminders, 08:00) gönderir; yerel zamanlama çift bildirim olur.
  bool _serverPushActive = false;

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

    const android = AndroidInitializationSettings('ic_stat_notification');
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

  NotificationDetails get _followUpDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'takipler',
          currentL10n.notifChannelFollowUps,
          channelDescription: currentL10n.notifChannelFollowUpsDesc,
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.private,
        ),
        iOS: const DarwinNotificationDetails(),
      );

  /// [notifyIfPast]: true ise uyarı saati geçmiş takiplerde anında bildir.
  /// Sync sırasında false olmalı — yoksa her dashboard açılışında tekrar basılır.
  Future<void> scheduleFollowUp(
    FollowUp f, {
    bool notifyIfPast = true,
  }) async {
    if (!_ready || f.tamamlandi) return;

    final when = tz.TZDateTime(
      tz.local,
      f.reminderDateOnly.year,
      f.reminderDateOnly.month,
      f.reminderDateOnly.day,
      9,
    );
    final l10n = currentL10n;
    final date = DateFormat.yMd().format(f.planDateOnly);
    final body = f.hatirlatmaGunOnce > 0
        ? l10n.notifCheckupBody(f.baslik, date)
        : f.baslik;
    final title =
        l10n.notifFollowUpTitle(f.hastaAdSoyad ?? l10n.patientFallback);
    final isPast = when.isBefore(tz.TZDateTime.now(tz.local));
    if (!isPast && _serverPushActive) return;
    if (isPast) {
      if (!notifyIfPast) return;
      // Yeni oluştururken: gecikmiş / bugün için tek seferlik bilgi
      await _plugin.show(
        id: _notifId(f.id),
        title: title,
        body: body,
        notificationDetails: _followUpDetails,
      );
      return;
    }

    await _plugin.zonedSchedule(
      id: _notifId(f.id),
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _followUpDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelFollowUp(String id) async {
    if (!_ready) return;
    await _plugin.cancel(id: _notifId(id));
  }

  /// Zamanlanmışları baştan kurar: başka cihazda tamamlanan / silinen
  /// takiplerin eski bildirimleri de böylece temizlenir.
  Future<void> syncOpenFollowUps(List<FollowUp> items) async {
    if (!_ready) return;
    await _plugin.cancelAllPendingNotifications();
    if (_serverPushActive) return;
    for (final f in items) {
      await scheduleFollowUp(f, notifyIfPast: false);
    }
  }

  Future<void> setServerPushActive(bool active) async {
    if (_serverPushActive == active) return;
    _serverPushActive = active;
    if (active && _ready) {
      await _plugin.cancelAllPendingNotifications();
    }
  }

  /// Çıkışta: bu cihazda önceki kullanıcıya ait bildirim kalmasın.
  Future<void> clearAll() async {
    _serverPushActive = false;
    if (!_ready) return;
    await _plugin.cancelAll();
  }

  /// Ön planda gelen FCM mesajını yerel bildirim olarak göster.
  Future<void> showImmediate({
    required String title,
    required String body,
  }) async {
    if (!_ready) return;
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch & 0x7fffffff,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'klinik_push',
          currentL10n.notifChannelClinic,
          channelDescription: currentL10n.notifChannelClinicDesc,
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.private,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
