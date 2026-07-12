import 'package:flutter/material.dart';

import '../models/clinic.dart';
import '../services/session_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt ol'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Klinik oluştur'),
            Tab(text: 'Kliniğe katıl'),
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
        SnackBar(content: Text(widget.session.error ?? '$e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Yeni klinik açarsınız; siz yönetici + doktor olursunuz. '
            'Asistanları klinik kodu ile davet edersiniz.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _clinic,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Klinik adı'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Klinik adı gerekli' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Ad Soyad'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ad soyad gerekli' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'E-posta'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
              if (!v.contains('@')) return 'Geçerli e-posta girin';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: 'Şifre',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 6) return 'En az 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Klinik oluştur'),
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
            child: const Text('Zaten hesabım var'),
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
        SnackBar(content: Text(widget.session.error ?? '$e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Yöneticiden aldığınız klinik kodu ile katılım isteği gönderin. '
            'Yönetici onayladıktan sonra kliniğe erişirsiniz.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _code,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Klinik kodu',
              hintText: 'örn. A3K9PX',
            ),
            validator: (v) =>
                (v == null || v.trim().length < 4) ? 'Kod gerekli' : null,
          ),
          const SizedBox(height: 12),
          Text('Rolüm', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ClinicRole>(
            segments: const [
              ButtonSegment(
                value: ClinicRole.doktor,
                label: Text('Doktor'),
                icon: Icon(Icons.medical_services_outlined),
              ),
              ButtonSegment(
                value: ClinicRole.asistan,
                label: Text('Asistan'),
                icon: Icon(Icons.support_agent),
              ),
            ],
            selected: {_role},
            onSelectionChanged: (s) => setState(() => _role = s.first),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Ad Soyad'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ad soyad gerekli' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-posta'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
              if (!v.contains('@')) return 'Geçerli e-posta girin';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Şifre',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (v) {
              if (v == null || v.length < 6) return 'En az 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Katıl'),
          ),
        ],
      ),
    );
  }
}
