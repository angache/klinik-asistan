import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      if (mounted) _snack('Hasta açılamadı: $e');
    }
  }

  void _call(String phone) => openExternalUrl(
        context,
        'tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}',
      );

  Future<void> _showActions(RecallPatient p) async {
    final hasPhone = (p.telefon ?? '').trim().isNotEmpty;
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
                subtitle: Text(hasPhone ? p.telefon! : 'Telefon kayıtlı değil'),
              ),
              const Divider(height: 1),
              if (hasPhone)
                ListTile(
                  leading: const Icon(Icons.call_outlined),
                  title: const Text('Ara'),
                  onTap: () => Navigator.pop(context, _RecallAction.call),
                ),
              ListTile(
                leading: const Icon(Icons.event_available_outlined),
                title: Text(RecallCallResult.randevu.label),
                subtitle: const Text('Kontrol tarihi seçilir, takip oluşur'),
                onTap: () => Navigator.pop(context, _RecallAction.randevu),
              ),
              ListTile(
                leading: const Icon(Icons.phone_missed_outlined),
                title: Text(RecallCallResult.ulasilamadi.label),
                subtitle: const Text('7 gün sonra listeye geri gelir'),
                onTap: () => Navigator.pop(context, _RecallAction.ulasilamadi),
              ),
              ListTile(
                leading: const Icon(Icons.do_not_disturb_on_outlined),
                title: Text(RecallCallResult.istemiyor.label),
                subtitle: const Text(
                  'Yeni bir işlem yapılana kadar listede görünmez',
                ),
                onTap: () => Navigator.pop(context, _RecallAction.istemiyor),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Hasta kartını aç'),
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
    try {
      final id = await widget.db.logRecallCall(p.id, result);
      if (!mounted) return;
      _snack(
        '${p.adSoyad}: ${result.label.toLowerCase()} olarak kaydedildi',
        action: SnackBarAction(
          label: 'Geri al',
          onPressed: () async {
            try {
              await widget.db.deleteRecallCall(id);
              if (mounted) await _reload();
            } catch (e) {
              if (mounted) _snack('Geri alınamadı: $e');
            }
          },
        ),
      );
      await _reload();
    } catch (e) {
      if (mounted) _snack('Kaydedilemedi: $e');
    }
  }

  Future<void> _giveAppointment(RecallPatient p) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day + 1),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      helpText: '${p.adSoyad} · kontrol tarihi',
      confirmText: 'Kaydet',
    );
    if (date == null || !mounted) return;
    final dateText = DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    try {
      final followUp = await widget.db.createFollowUp(
        hastaId: p.id,
        baslik: 'Periyodik kontrol',
        planlananTarih: date,
        aciklama: 'Kontrol nedeni: ${p.kontrolIslem} '
            '(${DateFormat('d MMM yyyy', 'tr_TR').format(p.kontrolIslemTarihi)})',
      );
      await NotificationService.instance.scheduleFollowUp(followUp);
      await widget.db.logRecallCall(
        p.id,
        RecallCallResult.randevu,
        aciklama: dateText,
      );
      if (!mounted) return;
      _snack('${p.adSoyad}: kontrol $dateText tarihine planlandı');
      await _reload();
    } catch (e) {
      if (mounted) _snack('Randevu kaydedilemedi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontrol çağrıları'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
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
    String label(String text, int? n) => n == null ? text : '$text ($n)';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.event_repeat_outlined),
              label: Text(label('Güncel', counts?.total)),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.history),
              label: Text(label('Eski hastalar', counts?.oldTotal)),
            ),
          ],
          selected: {_old},
          onSelectionChanged: (s) => _setOld(s.first),
        ),
        const SizedBox(height: 8),
        Text(
          _old
              ? 'Kontrol tarihi 12 aydan önce geçmiş hastalar. Uzun süredir '
                  'gelmedikleri için ayrı tutulur.'
              : 'Periyodik kontrol süresi tanımlı bir işlemden sonra süresi '
                  'dolan hastalar. Süreler İşlem şablonları ekranından '
                  'ayarlanır. Randevusu, planlı işlemi veya ileri tarihli '
                  'takibi olan hastalar listede görünmez.',
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
            'Liste yüklenemedi.\n\n$error',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.error),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar dene'),
          ),
        ],
      ),
    );
  }

  List<Widget> _patientTiles(BuildContext context, RecallList list) {
    final scheme = Theme.of(context).colorScheme;
    if (list.patients.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            _old
                ? 'Eski kontrol bekleyen hasta yok.'
                : 'Kontrol zamanı gelen hasta yok.',
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
            'İlk $shown hasta gösteriliyor. Arama sonucu kaydettikçe '
            'sıradakiler gelir.',
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
    final fmt = DateFormat('d MMM yyyy', 'tr_TR');
    final overdue = p.monthsOverdue(DateTime.now());
    final dueText = overdue == 0
        ? 'Kontrol: ${fmt.format(p.kontrolTarihi)}'
        : 'Kontrol: ${fmt.format(p.kontrolTarihi)} ($overdue ay gecikti)';

    String? callText;
    if (p.lastCallResult != null) {
      callText = [
        'Son arama: ${p.lastCallResult!.label}',
        if (p.lastCallAt != null)
          DateFormat('d MMM', 'tr_TR').format(p.lastCallAt!),
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
              tooltip: 'Ara: ${p.telefon}',
              icon: const Icon(Icons.call_outlined),
              onPressed: onCall,
            ),
    );
  }
}
