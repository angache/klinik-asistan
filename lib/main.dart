import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/auth_gate.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/session_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  await NotificationService.instance.init();

  final prefs = await SharedPreferences.getInstance();
  final savedMode = prefs.getString(_prefThemeMode);
  final savedPalette = prefs.getString(_prefThemePalette);

  final session = SessionController();
  final db = DatabaseService(session: session);

  runApp(KlinikAsistanApp(
    session: session,
    db: db,
    initialThemeMode: _parseThemeMode(savedMode),
    initialPalette: AppColorPaletteX.fromName(savedPalette),
  ));
}

const _prefThemeMode = 'theme_mode';
const _prefThemePalette = 'theme_palette';

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
  });

  final SessionController session;
  final DatabaseService db;
  final ThemeMode initialThemeMode;
  final AppColorPalette initialPalette;

  @override
  State<KlinikAsistanApp> createState() => KlinikAsistanAppState();

  static KlinikAsistanAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<KlinikAsistanAppState>();
  }
}

class KlinikAsistanAppState extends State<KlinikAsistanApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppColorPalette _palette = AppColorPalette.clinic;

  ThemeMode get themeMode => _themeMode;
  AppColorPalette get palette => _palette;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _palette = widget.initialPalette;
    AppTheme.activePalette = _palette;
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
      home: AuthGate(session: widget.session, db: widget.db),
    );
  }
}
