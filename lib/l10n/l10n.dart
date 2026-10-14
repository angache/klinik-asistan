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
