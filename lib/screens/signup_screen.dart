import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/clinic.dart';
import '../services/session_controller.dart';
import '../widgets/legal_consent_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.session});

  final SessionController session;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signupTitle),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l10n.createClinic),
            Tab(text: l10n.joinClinic),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: TabBarView(
            controller: _tabs,
            children: [
              _CreateClinicForm(session: widget.session),
              _JoinClinicForm(session: widget.session),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateClinicForm extends StatefulWidget {
  const _CreateClinicForm({required this.session});
  final SessionController session;

  @override
  State<_CreateClinicForm> createState() => _CreateClinicFormState();
}

class _CreateClinicFormState extends State<_CreateClinicForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _clinic = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _clinic.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await widget.session.signUpCreateClinic(
        email: _email.text,
        password: _password.text,
        adSoyad: _name.text,
        klinikAd: _clinic.text,
      );
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.session.error ?? errorText(e))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.signupCreateIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _clinic,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.clinicNameLabel),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.clinicNameRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fullNameLabel),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.fullNameRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: l10n.emailLabel),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!v.contains('@')) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 6) return l10n.passwordMinLength;
              return null;
            },
          ),
          const SizedBox(height: 12),
          LegalConsentField(),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.createClinic),
          ),
          TextButton(
            onPressed: _busy
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(session: widget.session),
                      ),
                    );
                  },
            child: Text(l10n.alreadyHaveAccount),
          ),
        ],
      ),
    );
  }
}

class _JoinClinicForm extends StatefulWidget {
  const _JoinClinicForm({required this.session});
  final SessionController session;

  @override
  State<_JoinClinicForm> createState() => _JoinClinicFormState();
}

class _JoinClinicFormState extends State<_JoinClinicForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  ClinicRole _role = ClinicRole.asistan;
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await widget.session.signUpJoinClinic(
        email: _email.text,
        password: _password.text,
        adSoyad: _name.text,
        klinikKod: _code.text,
        rol: _role,
      );
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.session.error ?? errorText(e))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.signupJoinIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _code,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l10n.clinicCodeLabel,
              hintText: l10n.clinicCodeHint,
            ),
            validator: (v) => (v == null || v.trim().length < 4)
                ? l10n.clinicCodeRequired
                : null,
          ),
          const SizedBox(height: 12),
          Text(l10n.myRole, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ClinicRole>(
            segments: [
              ButtonSegment(
                value: ClinicRole.doktor,
                label: Text(ClinicRole.doktor.label),
                icon: const Icon(Icons.medical_services_outlined),
              ),
              ButtonSegment(
                value: ClinicRole.asistan,
                label: Text(ClinicRole.asistan.label),
                icon: const Icon(Icons.support_agent),
              ),
            ],
            selected: {_role},
            onSelectionChanged: (s) => setState(() => _role = s.first),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fullNameLabel),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.fullNameRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.emailLabel),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!v.contains('@')) return l10n.emailInvalid;
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 6) return l10n.passwordMinLength;
              return null;
            },
          ),
          const SizedBox(height: 12),
          LegalConsentField(),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.joinButton),
          ),
        ],
      ),
    );
  }
}
