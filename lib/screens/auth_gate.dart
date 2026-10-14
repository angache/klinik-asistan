import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../services/database_service.dart';
import '../services/session_controller.dart';
import 'dashboard_screen.dart';
import 'join_requests_screen.dart';
import 'login_screen.dart';
import 'manage_clinics_screen.dart';
import 'settings_screen.dart';

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

        if (!session.hasClinic && session.membershipLoadFailed) {
          return _ConnectionErrorScreen(session: session);
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
              title: Text(context.l10n.clinicRequiredTitle),
              actions: [
                IconButton(
                  tooltip: context.l10n.settingsAndAccount,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(session: session),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => session.signOut(),
                  child: Text(context.l10n.signOut),
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

class _ConnectionErrorScreen extends StatelessWidget {
  const _ConnectionErrorScreen({required this.session});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klinik Asistan'),
        actions: [
          TextButton(
            onPressed: () => session.signOut(),
            child: Text(l10n.signOut),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 56, color: scheme.error),
              const SizedBox(height: 16),
              Text(
                l10n.serverUnreachableTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.serverUnreachableBody,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => session.refreshMembership(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Klinik kodunu kopyalama için küçük yardımcı.
Future<void> copyClinicCode(BuildContext context, String kod) async {
  await Clipboard.setData(ClipboardData(text: kod));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(context.l10n.clinicCodeCopied(kod))),
  );
}
