import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
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
    final l10n = context.l10n;
    final tabItems = [
      Tab(text: l10n.createClinic),
      Tab(text: l10n.joinClinic),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: embedded
            ? null
            : AppBar(
                title: Text(l10n.myClinics),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: tabItems,
                ),
              ),
        body: Column(
          children: [
            if (embedded) Material(child: TabBar(tabs: tabItems)),
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
          content: Text(context.l10n.clinicCreated(created.ad, created.kod)),
        ),
      );
      if (widget.popOnSuccess) {
        Navigator.of(context).pop(true);
      }
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
            l10n.manageCreateIntro,
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
          const SizedBox(height: 24),
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
        SnackBar(content: Text(context.l10n.joinRequestSent)),
      );
      if (widget.popOnSuccess) {
        Navigator.of(context).pop(true);
      }
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
            l10n.manageJoinIntro,
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
          const SizedBox(height: 24),
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
