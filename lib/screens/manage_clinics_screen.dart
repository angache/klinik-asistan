import 'package:flutter/material.dart';

import '../models/clinic.dart';
import '../services/session_controller.dart';

/// Girişliyken klinik oluştur / başka kliniğe katıl.
class ManageClinicsScreen extends StatelessWidget {
  const ManageClinicsScreen({
    super.key,
    required this.session,
    this.embedded = false,
  });

  final SessionController session;

  /// true: AuthGate içinde (üst AppBar dışarıda), false: kendi AppBar'ı var.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final tabs = const TabBar(
      tabs: [
        Tab(text: 'Klinik oluştur'),
        Tab(text: 'Kliniğe katıl'),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: embedded
            ? null
            : AppBar(
                title: const Text('Kliniklerim'),
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: 'Klinik oluştur'),
                    Tab(text: 'Kliniğe katıl'),
                  ],
                ),
              ),
        body: Column(
          children: [
            if (embedded) Material(child: tabs),
            Expanded(
              child: TabBarView(
                children: [
                  _CreateForm(session: session, popOnSuccess: !embedded),
                  _JoinForm(session: session, popOnSuccess: !embedded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateForm extends StatefulWidget {
  const _CreateForm({
    required this.session,
    required this.popOnSuccess,
  });
  final SessionController session;
  final bool popOnSuccess;

  @override
  State<_CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<_CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _clinic = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _clinic.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final created = await widget.session.createAdditionalClinic(
        klinikAd: _clinic.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${created.ad} oluşturuldu. Kod: ${created.kod}',
          ),
        ),
      );
      if (widget.popOnSuccess) {
        Navigator.of(context).pop(true);
      }
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
            'Yeni bir klinik açarsınız; bu klinikte yönetici olursunuz. '
            'Diğer klinikleriniz silinmez — aralarında geçiş yapabilirsiniz.',
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
        ],
      ),
    );
  }
}

class _JoinForm extends StatefulWidget {
  const _JoinForm({
    required this.session,
    required this.popOnSuccess,
  });
  final SessionController session;
  final bool popOnSuccess;

  @override
  State<_JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<_JoinForm> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  ClinicRole _role = ClinicRole.doktor;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await widget.session.joinAdditionalClinic(
        klinikKod: _code.text,
        rol: _role,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Katılım isteği gönderildi. Yönetici onayı bekleniyor.'),
        ),
      );
      if (widget.popOnSuccess) {
        Navigator.of(context).pop(true);
      }
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
            'Klinik kodunu girin. Yönetici onayladıktan sonra kliniğe erişirsiniz.',
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
