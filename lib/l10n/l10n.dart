import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Uygulamada seçilebilen diller; yerel adlarıyla gösterilir, çevrilmez.
const kLanguageNames = <String, String>{
  'tr': 'Türkçe',
  'en': 'English',
  'de': 'Deutsch',
  'ru': 'Русский',
  'fr': 'Français',
  'es': 'Español',
};

const _fallbackLocale = Locale('en');
Locale _activeLocale = _fallbackLocale;

Locale get activeLocale => _activeLocale;

/// Widget ağacı dışındaki metinler (servis hataları, bildirimler, model
/// etiketleri) için etkin dil.
AppLocalizations get currentL10n => lookupAppLocalizations(_activeLocale);

/// [preferred] null ise cihaz dili kullanılır; desteklenmiyorsa İngilizce.
Locale resolveAppLocale(Locale? preferred, Iterable<Locale> deviceLocales) {
  final supported =
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
  for (final l in [if (preferred != null) preferred, ...deviceLocales]) {
    if (supported.contains(l.languageCode)) return Locale(l.languageCode);
  }
  return _fallbackLocale;
}

void setActiveLocale(Locale locale) {
  _activeLocale = locale;
  Intl.defaultLocale = locale.languageCode;
}

/// Hata metni. Veritabanı fonksiyonlarının hataları Türkçe gelir; bilinenler
/// etkin dile çevrilir, diğerleri olduğu gibi gösterilir.
String errorText(Object? error) {
  final raw = '$error';
  final l = currentL10n;
  for (final (server, text) in [
    ('Oturum gerekli', l.errSessionRequired),
    ('Rol doktor veya asistan olmalı', l.errRoleInvalid),
    ('Klinik kodu bulunamadı', l.errClinicCodeNotFound),
    ('zaten üyesiniz', l.errAlreadyMember),
    ('İstek bulunamadı', l.errRequestNotFound),
    ('Sadece klinik yöneticisi', l.errOnlyAdminCanApprove),
    ('istek zaten yanıtlanmış', l.errRequestAlreadyAnswered),
    ('Sorumlu üye görevle aynı klinikte', l.errAssigneeOtherClinic),
    ('Hasta görevle aynı klinikte', l.errPatientOtherClinic),
    ('raporlarını görme yetkiniz yok', l.errNoReportPermission),
    ('Geçersiz tarih aralığı', l.errInvalidDateRange),
    ('listesini görme yetkiniz yok', l.errNoListPermission),
    ('Bu kliniğe üye değilsiniz', l.errNotMember),
    ('Kaydedilecek not yok', l.errNothingToSave),
    ('Not bulunamadı', l.errNoteNotFound),
    ('row-level security', l.errNoPermission),
    ('SocketException', l.errOffline),
    ('Failed host lookup', l.errOffline),
  ]) {
    if (raw.contains(server)) return text;
  }
  return raw;
}
