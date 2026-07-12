import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/database_service.dart';
import '../services/session_controller.dart';
import 'dashboard_screen.dart';
import 'join_requests_screen.dart';
import 'login_screen.dart';
import 'manage_clinics_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.session,
    required this.db,
  });

  final SessionController session;
  final DatabaseService db;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        if (session.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!session.isLoggedIn) {
          return LoginScreen(session: session);
        }

        if (!session.hasClinic) {
          if (session.hasPendingJoinRequests) {
            return PendingJoinScreen(
              session: session,
              onCreateOrJoin: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ManageClinicsScreen(session: session),
                  ),
                );
              },
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Klinik gerekli'),
              actions: [
                TextButton(
                  onPressed: () => session.signOut(),
                  child: const Text('Çıkış'),
                ),
              ],
            ),
            body: ManageClinicsScreen(
              session: session,
              embedded: true,
            ),
          );
        }

        return DashboardScreen(
          key: ValueKey(session.klinikId),
          db: db,
          session: session,
        );
      },
    );
  }
}

/// Klinik kodunu kopyalama için küçük yardımcı.
Future<void> copyClinicCode(BuildContext context, String kod) async {
  await Clipboard.setData(ClipboardData(text: kod));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Klinik kodu kopyalandı: $kod')),
  );
}
