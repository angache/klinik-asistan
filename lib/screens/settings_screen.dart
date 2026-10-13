import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/legal_config.dart';
import '../services/session_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.session});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final links = <(String, IconData, String)>[
      if (LegalConfig.kvkkNoticeUrl.isNotEmpty)
        (
          'KVKK aydınlatma metni',
          Icons.policy_outlined,
          LegalConfig.kvkkNoticeUrl
        ),
      if (LegalConfig.privacyPolicyUrl.isNotEmpty)
        (
          'Gizlilik politikası',
          Icons.privacy_tip_outlined,
          LegalConfig.privacyPolicyUrl
        ),
      if (LegalConfig.termsUrl.isNotEmpty)
        (
          'Kullanım koşulları',
          Icons.description_outlined,
          LegalConfig.termsUrl
        ),
      if (LegalConfig.supportEmail.isNotEmpty)
        (
          'Destek: ${LegalConfig.supportEmail}',
          Icons.mail_outline,
          'mailto:${LegalConfig.supportEmail}'
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _Section('Hesap'),
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
          if (links.isNotEmpty) ...[
            const Divider(),
            const _Section('Yasal'),
            for (final (title, icon, url) in links)
              ListTile(
                leading: Icon(icon),
                title: Text(title),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => openExternalUrl(context, url),
              ),
          ],
          const Divider(),
          _Section('Tehlikeli bölge', color: scheme.error),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: scheme.error),
            title: Text(
              'Hesabımı sil',
              style: TextStyle(color: scheme.error),
            ),
            subtitle: const Text('Hesabınız kalıcı olarak silinir'),
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final AccountDeletionPreview preview;
    try {
      preview = await _withProgress(context, session.previewAccountDeletion());
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Hesap bilgisi alınamadı: ${_message(e)}')),
      );
      return;
    }
    if (!context.mounted) return;

    if (!preview.canDelete) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Önce yöneticiyi devredin'),
          content: Text(
            'Şu kliniklerin tek yöneticisisiniz ve başka üyeleri var:\n\n'
            '${preview.blockingClinics.map((e) => '• $e').join('\n')}\n\n'
            'Üyeler ekranından başka bir üyeyi yönetici yapın, '
            'sonra tekrar deneyin.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tamam'),
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
        const SnackBar(content: Text('Hesabınız silindi')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Hesap silinemedi: ${_message(e)}')),
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
      return 'Sunucu hatası (${e.status})';
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
      SnackBar(content: Text('Bağlantı açılamadı: $url')),
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
  static const _confirmWord = 'SİL';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clinics = widget.preview.clinicsToDelete;
    // "sil", "SIL", "SİL" hepsi kabul (Dart toUpperCase Türkçe İ bilmez).
    final matches =
        _controller.text.trim().toUpperCase().replaceAll('İ', 'I') == 'SIL';

    return AlertDialog(
      title: const Text('Hesabı kalıcı olarak sil'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesabınız ve giriş bilgileriniz silinir. Bu işlem geri alınamaz.',
            ),
            if (clinics.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Aşağıdaki kliniklerin tek üyesisiniz. Bu klinikler tüm '
                'hasta kayıtları, işlemler, fotoğraflar ve ses kayıtlarıyla '
                'birlikte silinecek:',
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(clinics.map((e) => '• $e').join('\n')),
            ] else ...[
              const SizedBox(height: 12),
              const Text(
                'Üyesi olduğunuz kliniklerdeki kayıtlar klinikte kalır; '
                'yalnızca üyeliğiniz sonlanır.',
              ),
            ],
            const SizedBox(height: 16),
            const Text('Onaylamak için "$_confirmWord" yazın:'),
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
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error),
          onPressed: matches ? () => Navigator.pop(context, true) : null,
          child: const Text('Hesabı sil'),
        ),
      ],
    );
  }
}
