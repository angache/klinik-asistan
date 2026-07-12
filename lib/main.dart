import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/auth_gate.dart';
import 'services/database_service.dart';
import 'services/session_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  final session = SessionController();
  final db = DatabaseService(session: session);

  runApp(KlinikAsistanApp(session: session, db: db));
}

class KlinikAsistanApp extends StatefulWidget {
  const KlinikAsistanApp({
    super.key,
    required this.session,
    required this.db,
  });

  final SessionController session;
  final DatabaseService db;

  @override
  State<KlinikAsistanApp> createState() => KlinikAsistanAppState();

  static KlinikAsistanAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<KlinikAsistanAppState>();
  }
}

class KlinikAsistanAppState extends State<KlinikAsistanApp> {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void cycleThemeMode() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
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
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: AuthGate(session: widget.session, db: widget.db),
    );
  }
}
