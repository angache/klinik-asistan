import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/legal_config.dart';
import '../l10n/l10n.dart';
import '../main.dart';
import '../services/session_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.session});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final links = <(String, IconData, String)>[
      if (LegalConfig.kvkkNoticeUrl.isNotEmpty)
        (l10n.privacyNotice, Icons.policy_outlined, LegalConfig.kvkkNoticeUrl),
      if (LegalConfig.privacyPolicyUrl.isNotEmpty)
        (
          l10n.privacyPolicy,
          Icons.privacy_tip_outlined,
          LegalConfig.privacyPolicyUrl
        ),
      if (LegalConfig.termsUrl.isNotEmpty)
        (l10n.termsOfUse, Icons.description_outlined, LegalConfig.termsUrl),
      if (LegalConfig.supportEmail.isNotEmpty)
        (
          l10n.supportEmail(LegalConfig.supportEmail),
          Icons.mail_outline,
          'mailto:${LegalConfig.supportEmail}'
        ),
    ];
    final selectedLocale = KlinikAsistanApp.of(context)?.locale;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _Section(l10n.settingsAccountSection),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(session.displayName),
            subtitle: Text(session.user?.email ?? ''),
          ),
          if (session.clinic != null)
            ListTile(
              leading: const Icon(Icons.local_hospital_outlined),
              title: Text(session.clinic!.ad),
              subtitle: Text(session.member?.rol.label ?? ''),
            ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageLabel),
            subtitle: Text(
              selectedLocale == null
                  ? l10n.languageSystem
                  : kLanguageNames[selectedLocale.languageCode] ??
                      selectedLocale.languageCode,
            ),
            onTap: () => _pickLanguage(context, selectedLocale),
          ),
          if (links.isNotEmpty) ...[
            const Divider(),
            _Section(l10n.settingsLegalSection),
            for (final (title, icon, url) in links)
              ListTile(
                leading: Icon(icon),
                title: Text(title),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => openExternalUrl(context, url),
              ),
          ],
          const Divider(),
          _Section(l10n.settingsDangerZone, color: scheme.error),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: scheme.error),
            title: Text(
              l10n.deleteMyAccount,
              style: TextStyle(color: scheme.error),
            ),
            subtitle: Text(l10n.deleteMyAccountSubtitle),
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context, Locale? current) async {
    final app = KlinikAsistanApp.of(context);
    if (app == null) return;
    // '' = telefonun dili.
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(ctx.l10n.languageLabel),
        children: [
          for (final (code, name) in [
            ('', ctx.l10n.languageSystem),
            ...kLanguageNames.entries.map((e) => (e.key, e.value)),
          ])
            ListTile(
              leading: Icon(
                code == (current?.languageCode ?? '')
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Theme.of(ctx).colorScheme.primary,
              ),
              title: Text(name),
              onTap: () => Navigator.pop(ctx, code),
            ),
        ],
      ),
    );
    if (picked == null) return;
    await app.setLocale(picked.isEmpty ? null : Locale(picked));
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;

    final AccountDeletionPreview preview;
    try {
      preview = await _withProgress(context, session.previewAccountDeletion());
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.accountInfoFailed(_message(e)))),
      );
      return;
    }
    if (!context.mounted) return;

    if (!preview.canDelete) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.transferAdminTitle),
          content: Text(
            l10n.transferAdminBody(
              preview.blockingClinics.map((e) => '• $e').join('\n'),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteConfirmDialog(preview: preview),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await _withProgress(context, session.deleteAccount());
      navigator.popUntil((r) => r.isFirst);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.accountDeleted)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.accountDeleteFailed(_message(e)))),
      );
    }
  }

  static Future<T> _withProgress<T>(BuildContext context, Future<T> work) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
    return work.whenComplete(() {
      if (context.mounted) Navigator.of(context).pop();
    });
  }

  static String _message(Object e) {
    if (e is FunctionException) {
      final details = e.details;
      if (details is Map && details['error'] != null) {
        return details['error'].toString();
      }
      return currentL10n.serverError(e.status);
    }
    return e.toString();
  }
}

Future<void> openExternalUrl(BuildContext context, String url) async {
  final ok = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.linkOpenFailed(url))),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, {this.color});

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _DeleteConfirmDialog extends StatefulWidget {
  const _DeleteConfirmDialog({required this.preview});

  final AccountDeletionPreview preview;

  @override
  State<_DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<_DeleteConfirmDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Dart'ın toUpperCase'i Türkçe İ'yi bilmez: "sil", "SIL", "SİL" hepsi kabul.
  static String _normalize(String s) =>
      s.trim().toUpperCase().replaceAll('İ', 'I');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final clinics = widget.preview.clinicsToDelete;
    final confirmWord = l10n.deleteAccountConfirmWord;
    final matches = _normalize(_controller.text) == _normalize(confirmWord);

    return AlertDialog(
      title: Text(l10n.deleteAccountTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteAccountWarning),
            if (clinics.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.deleteAccountClinicsWarning,
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(clinics.map((e) => '• $e').join('\n')),
            ] else ...[
              const SizedBox(height: 12),
              Text(l10n.deleteAccountMembershipOnly),
            ],
            const SizedBox(height: 16),
            Text(l10n.deleteAccountTypeToConfirm(confirmWord)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error),
          onPressed: matches ? () => Navigator.pop(context, true) : null,
          child: Text(l10n.deleteAccountButton),
        ),
      ],
    );
  }
}
