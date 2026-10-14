import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
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
          SnackBar(content: Text(context.l10n.resetCodeSent)),
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
          SnackBar(content: Text(context.l10n.passwordUpdated)),
        );
        Navigator.of(context).popUntil((r) => r.isFirst);
      });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  _codeSent ? l10n.resetIntroCode : l10n.resetIntroEmail,
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  enabled: !_codeSent,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.emailRequired;
                    }
                    if (!v.contains('@')) return l10n.emailInvalid;
                    return null;
                  },
                ),
                if (_codeSent) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: InputDecoration(labelText: l10n.resetCodeLabel),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (!RegExp(r'^\d{6,10}$').hasMatch(t)) {
                        return l10n.resetCodeInvalid;
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
                      labelText: l10n.newPasswordLabel,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? l10n.passwordMinLength
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password2,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: l10n.newPasswordRepeatLabel,
                    ),
                    validator: (v) =>
                        v != _password.text ? l10n.passwordsDoNotMatch : null,
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
                      : Text(
                          _codeSent
                              ? l10n.updatePasswordButton
                              : l10n.sendCodeButton,
                        ),
                ),
                if (_codeSent)
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _codeSent = false;
                              _code.clear();
                            }),
                    child: Text(l10n.resetRequestNewCode),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
