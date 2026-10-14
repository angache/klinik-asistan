import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import '../models/clinic_report.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'patient_detail_screen.dart';
import 'settings_screen.dart' show openExternalUrl;

/// Periyodik kontrol zamanı gelen hastalar ve arama sonuçları.
class RecallScreen extends StatefulWidget {
  const RecallScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<RecallScreen> createState() => _RecallScreenState();
}

class _RecallScreenState extends State<RecallScreen> {
  bool _old = false;
  late Future<RecallList> _future = _load();
  RecallList? _last;

  Future<RecallList> _load() async {
    final list = await widget.db.getRecallPatients(old: _old);
    _last = list;
    return list;
  }

  Future<void> _reload() async {
    setState(() => _future = _load());
    try {
      await _future;
    } catch (_) {}
  }

  void _setOld(bool old) {
    if (old == _old) return;
    _old = old;
    _reload();
  }

  void _snack(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text), action: action));
  }

  Future<void> _openPatient(RecallPatient p) async {
    try {
      final patient = await widget.db.getPatient(p.id);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PatientDetailScreen(patient: patient, db: widget.db),
        ),
      );
      if (mounted) await _reload();
    } catch (e) {
      if (mounted) _snack(context.l10n.patientOpenFailed(errorText(e)));
    }
  }

  void _call(String phone) => openExternalUrl(
        context,
        'tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}',
      );

  Future<void> _showActions(RecallPatient p) async {
    final hasPhone = (p.telefon ?? '').trim().isNotEmpty;
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<_RecallAction>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(
                  p.adSoyad,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(hasPhone ? p.telefon! : l10n.noPhone),
              ),
              const Divider(height: 1),
              if (hasPhone)
                ListTile(
                  leading: const Icon(Icons.call_outlined),
                  title: Text(l10n.call),
                  onTap: () => Navigator.pop(context, _RecallAction.call),
                ),
              ListTile(
                leading: const Icon(Icons.event_available_outlined),
                title: Text(RecallCallResult.randevu.label),
                subtitle: Text(l10n.recallAppointmentHint),
                onTap: () => Navigator.pop(context, _RecallAction.randevu),
              ),
              ListTile(
                leading: const Icon(Icons.phone_missed_outlined),
                title: Text(RecallCallResult.ulasilamadi.label),
                subtitle: Text(l10n.recallUnreachableHint),
                onTap: () => Navigator.pop(context, _RecallAction.ulasilamadi),
              ),
              ListTile(
                leading: const Icon(Icons.do_not_disturb_on_outlined),
                title: Text(RecallCallResult.istemiyor.label),
                subtitle: Text(l10n.recallDeclinedHint),
                onTap: () => Navigator.pop(context, _RecallAction.istemiyor),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.openPatientCard),
                onTap: () => Navigator.pop(context, _RecallAction.open),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;
    switch (choice) {
      case _RecallAction.call:
        _call(p.telefon!);
      case _RecallAction.open:
        await _openPatient(p);
      case _RecallAction.randevu:
        await _giveAppointment(p);
      case _RecallAction.ulasilamadi:
        await _log(p, RecallCallResult.ulasilamadi);
      case _RecallAction.istemiyor:
        await _log(p, RecallCallResult.istemiyor);
    }
  }

  Future<void> _log(RecallPatient p, RecallCallResult result) async {
    final l10n = context.l10n;
    try {
      final id = await widget.db.logRecallCall(p.id, result);
      if (!mounted) return;
      _snack(
        l10n.recallLogged(p.adSoyad, result.label),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () async {
            try {
              await widget.db.deleteRecallCall(id);
              if (mounted) await _reload();
            } catch (e) {
              if (mounted) _snack(l10n.undoFailed(errorText(e)));
            }
          },
        ),
      );
      await _reload();
    } catch (e) {
      if (mounted) _snack(l10n.saveFailed(errorText(e)));
    }
  }

  Future<void> _giveAppointment(RecallPatient p) async {
    final now = DateTime.now();
    final l10n = context.l10n;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day + 1),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      helpText: l10n.recallDateHelp(p.adSoyad),
      confirmText: l10n.save,
    );
    if (date == null || !mounted) return;
    final dateText = DateFormat.yMMMMd().format(date);
    try {
      final followUp = await widget.db.createFollowUp(
        hastaId: p.id,
        baslik: l10n.periodicCheckup,
        planlananTarih: date,
        aciklama: l10n.checkupReason(
          p.kontrolIslem,
          DateFormat.yMMMd().format(p.kontrolIslemTarihi),
        ),
      );
      await NotificationService.instance.scheduleFollowUp(followUp);
      await widget.db.logRecallCall(
        p.id,
        RecallCallResult.randevu,
        aciklama: dateText,
      );
      if (!mounted) return;
      _snack(l10n.checkupScheduled(p.adSoyad, dateText));
      await _reload();
    } catch (e) {
      if (mounted) _snack(l10n.appointmentSaveFailed(errorText(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.recalls),
        actions: [
          IconButton(
            tooltip: context.l10n.refresh,
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<RecallList>(
          future: _future,
          builder: (context, snap) {
            final counts = snap.data ?? _last;
            final children = <Widget>[
              _header(context, counts),
              const SizedBox(height: 8),
            ];
            if (snap.connectionState != ConnectionState.done) {
              children.add(const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ));
            } else if (snap.hasError) {
              children.add(_error(context, snap.error));
            } else {
              children.addAll(_patientTiles(context, snap.data!));
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context, RecallList? counts) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    String label(String text, int? n) => n == null ? text : '$text ($n)';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.event_repeat_outlined),
              label: Text(label(l10n.recallCurrent, counts?.total)),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.history),
              label: Text(label(l10n.recallOld, counts?.oldTotal)),
            ),
          ],
          selected: {_old},
          onSelectionChanged: (s) => _setOld(s.first),
        ),
        const SizedBox(height: 8),
        Text(
          _old ? l10n.recallOldHint : l10n.recallCurrentHint,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _error(BuildContext context, Object? error) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            context.l10n.loadFailed(errorText(error)),
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.error),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }

  List<Widget> _patientTiles(BuildContext context, RecallList list) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    if (list.patients.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            _old ? l10n.noOldRecalls : l10n.noRecallsDue,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      ];
    }
    final shown = list.patients.length;
    final total = _old ? list.oldTotal : list.total;
    return [
      for (final p in list.patients)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: _RecallTile(
            patient: p,
            onTap: () => _showActions(p),
            onCall: (p.telefon ?? '').trim().isEmpty
                ? null
                : () => _call(p.telefon!),
          ),
        ),
      if (total > shown)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${l10n.firstNPatients(shown)} ${l10n.moreAfterLogging}',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
    ];
  }
}

enum _RecallAction { call, randevu, ulasilamadi, istemiyor, open }

class _RecallTile extends StatelessWidget {
  const _RecallTile({required this.patient, required this.onTap, this.onCall});

  final RecallPatient patient;
  final VoidCallback onTap;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final p = patient;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final fmt = DateFormat.yMMMd();
    final overdue = p.monthsOverdue(DateTime.now());
    final dueText = overdue == 0
        ? l10n.checkupDue(fmt.format(p.kontrolTarihi))
        : l10n.checkupOverdue(fmt.format(p.kontrolTarihi), overdue);

    String? callText;
    if (p.lastCallResult != null) {
      callText = [
        l10n.lastCall(p.lastCallResult!.label),
        if (p.lastCallAt != null) DateFormat.MMMd().format(p.lastCallAt!),
        if ((p.lastCallBy ?? '').trim().isNotEmpty) p.lastCallBy!,
      ].join(' · ');
    }

    return ListTile(
      onTap: onTap,
      title: Text(
        p.adSoyad,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${p.kontrolIslem} · ${fmt.format(p.kontrolIslemTarihi)}'),
          Text(
            dueText,
            style: TextStyle(
              color: overdue >= 3 ? scheme.error : scheme.onSurfaceVariant,
            ),
          ),
          if (callText != null)
            Text(
              callText,
              style: textTheme.bodySmall?.copyWith(color: scheme.tertiary),
            ),
        ],
      ),
      trailing: onCall == null
          ? const Icon(Icons.more_vert)
          : IconButton(
              tooltip: l10n.callPhone(p.telefon!),
              icon: const Icon(Icons.call_outlined),
              onPressed: onCall,
            ),
    );
  }
}
