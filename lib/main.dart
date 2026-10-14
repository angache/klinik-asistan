import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'l10n/l10n.dart';
import 'screens/auth_gate.dart';
import 'services/crash_reporting.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/push_service.dart';
import 'services/session_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CrashReporting.init();
  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString(_prefLanguage);
  final preferredLocale = savedLanguage == null ? null : Locale(savedLanguage);
  setActiveLocale(resolveAppLocale(
    preferredLocale,
    WidgetsBinding.instance.platformDispatcher.locales,
  ));

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  await NotificationService.instance.init();
  await PushService.instance.init();

  final savedMode = prefs.getString(_prefThemeMode);
  final savedPalette = prefs.getString(_prefThemePalette);

  final session = SessionController();
  final db = DatabaseService(session: session);

  runApp(KlinikAsistanApp(
    session: session,
    db: db,
    initialThemeMode: _parseThemeMode(savedMode),
    initialPalette: AppColorPaletteX.fromName(savedPalette),
    initialLocale: preferredLocale,
  ));
}

const _prefThemeMode = 'theme_mode';
const _prefThemePalette = 'theme_palette';
const _prefLanguage = 'app_language';

ThemeMode _parseThemeMode(String? raw) {
  return switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

class KlinikAsistanApp extends StatefulWidget {
  const KlinikAsistanApp({
    super.key,
    required this.session,
    required this.db,
    this.initialThemeMode = ThemeMode.system,
    this.initialPalette = AppColorPalette.clinic,
    this.initialLocale,
  });

  final SessionController session;
  final DatabaseService db;
  final ThemeMode initialThemeMode;
  final AppColorPalette initialPalette;

  /// null = telefonun dili.
  final Locale? initialLocale;

  @override
  State<KlinikAsistanApp> createState() => KlinikAsistanAppState();

  static KlinikAsistanAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<KlinikAsistanAppState>();
  }
}

class KlinikAsistanAppState extends State<KlinikAsistanApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppColorPalette _palette = AppColorPalette.clinic;
  Locale? _locale;

  ThemeMode get themeMode => _themeMode;
  AppColorPalette get palette => _palette;

  /// Kullanıcının seçtiği dil; null = telefonun dili.
  Locale? get locale => _locale;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _palette = widget.initialPalette;
    _locale = widget.initialLocale;
    AppTheme.activePalette = _palette;
  }

  Future<void> setLocale(Locale? locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefLanguage);
    } else {
      await prefs.setString(_prefLanguage, locale.languageCode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefThemeMode,
      switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      },
    );
  }

  Future<void> setPalette(AppColorPalette palette) async {
    setState(() {
      _palette = palette;
      AppTheme.activePalette = palette;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefThemePalette, palette.name);
  }

  void cycleThemeMode() {
    final next = switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    setThemeMode(next);
  }

  @override
  void dispose() {
    widget.session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Asistan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(_palette),
      darkTheme: AppTheme.dark(_palette),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (deviceLocales, _) {
        final resolved = resolveAppLocale(_locale, deviceLocales ?? const []);
        setActiveLocale(resolved);
        return resolved;
      },
      home: AuthGate(session: widget.session, db: widget.db),
    );
  }
}
