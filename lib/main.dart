import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/dashboard_screen.dart';
import 'services/database_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(KlinikAsistanApp(db: DatabaseService()));
}

class KlinikAsistanApp extends StatelessWidget {
  const KlinikAsistanApp({super.key, required this.db});

  final DatabaseService db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Asistan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: DashboardScreen(db: db),
    );
  }
}
