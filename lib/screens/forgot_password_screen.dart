import 'package:flutter/material.dart';

import '../services/session_controller.dart';

/// E-postaya gelen kodla şifre sıfırlama (deep link gerektirmez; Windows'ta da
/// çalışır).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.session,
    this.initialEmail = '',
  });

  final SessionController session;
  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() => _run(() async {
        await widget.session.sendPasswordResetCode(_email.text);
        if (!mounted) return;
        setState(() => _codeSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıtlıysa e-posta adresinize kod gönderildi'),
          ),
        );
      });

  Future<void> _reset() => _run(() async {
        await widget.session.resetPasswordWithCode(
          email: _email.text,
          code: _code.text,
          newPassword: _password.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şifreniz güncellendi')),
        );
        Navigator.of(context).popUntil((r) => r.isFirst);
      });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Şifremi unuttum')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  _codeSent
                      ? 'E-postanıza gelen kodu ve yeni şifrenizi girin.'
                      : 'Hesabınızın e-posta adresini girin; size bir '
                          'sıfırlama kodu gönderelim.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  enabled: !_codeSent,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'E-posta'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
                    if (!v.contains('@')) return 'Geçerli e-posta girin';
                    return null;
                  },
                ),
                if (_codeSent) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: const InputDecoration(labelText: 'Kod'),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (!RegExp(r'^\d{6,10}$').hasMatch(t)) {
                        return 'E-postadaki kodu girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'Yeni şifre',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'En az 6 karakter' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password2,
                    obscureText: _obscure,
                    decoration:
                        const InputDecoration(labelText: 'Yeni şifre (tekrar)'),
                    validator: (v) =>
                        v != _password.text ? 'Şifreler aynı değil' : null,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _busy ? null : (_codeSent ? _reset : _sendCode),
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_codeSent ? 'Şifreyi güncelle' : 'Kod gönder'),
                ),
                if (_codeSent)
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _codeSent = false;
                              _code.clear();
                            }),
                    child: const Text('Yeni kod iste / e-postayı değiştir'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
