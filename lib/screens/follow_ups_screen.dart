import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import '../models/follow_up.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'patient_detail_screen.dart';

class FollowUpsScreen extends StatefulWidget {
  const FollowUpsScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

class _FollowUpsScreenState extends State<FollowUpsScreen> {
  late Future<List<FollowUp>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.db.getOpenFollowUps();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.db.getOpenFollowUps());
    await _future;
  }

  Future<void> _complete(FollowUp f) async {
    final l10n = context.l10n;
    try {
      await widget.db.completeFollowUp(f.id);
      await NotificationService.instance.cancelFollowUp(f.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.completedItem(f.baslik))),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.actionFailed('$e'))),
      );
    }
  }

  Future<void> _delete(FollowUp f) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteFollowUpTitle),
        content: Text(l10n.deleteItemConfirm(f.baslik)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.db.deleteFollowUp(f.id);
      await NotificationService.instance.cancelFollowUp(f.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deletedItem(f.baslik))),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteFailed('$e'))),
      );
    }
  }

  Future<void> _openPatient(FollowUp f) async {
    try {
      final patient = await widget.db.getPatient(f.hastaId);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PatientDetailScreen(patient: patient, db: widget.db),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.patientOpenFailed('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fmt = DateFormat.yMd();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.followUps)),
      body: FutureBuilder<List<FollowUp>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.loadFailed('${snap.error}')),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reload,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = snap.data ?? [];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text(l10n.noOpenFollowUps)),
                ],
              ),
            );
          }

          final overdue = items.where((e) => e.isOverdue).toList();
          final today = items.where((e) => e.isDueToday).toList();
          final reminded = items.where((e) => e.isReminderDue).toList();
          final upcoming = items.where((e) => !e.needsAttention).toList();

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (overdue.isNotEmpty) ...[
                  _sectionTitle(context, l10n.sectionOverdue, Colors.red),
                  ...overdue.map((f) => _tile(context, f, fmt)),
                  const SizedBox(height: 12),
                ],
                if (today.isNotEmpty) ...[
                  _sectionTitle(
                    context,
                    l10n.today,
                    Theme.of(context).colorScheme.primary,
                  ),
                  ...today.map((f) => _tile(context, f, fmt)),
                  const SizedBox(height: 12),
                ],
                if (reminded.isNotEmpty) ...[
                  _sectionTitle(
                    context,
                    l10n.sectionReminderDue,
                    Colors.orange.shade800,
                  ),
                  ...reminded.map((f) => _tile(context, f, fmt)),
                  const SizedBox(height: 12),
                ],
                if (upcoming.isNotEmpty) ...[
                  _sectionTitle(context, l10n.sectionUpcoming, null),
                  ...upcoming.map((f) => _tile(context, f, fmt)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, Color? color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
      ),
    );
  }

  Widget _tile(BuildContext context, FollowUp f, DateFormat fmt) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final accent = f.isOverdue
        ? scheme.error
        : f.isDueToday
            ? scheme.primary
            : f.isReminderDue
                ? Colors.orange.shade800
                : scheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: f.isLab
            ? Icon(Icons.science_outlined, color: accent)
            : Icon(Icons.event_note_outlined, color: accent),
        title: Text(
          f.hastaAdSoyad ?? l10n.patientFallback,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(f.baslik),
            if (f.aciklama != null && f.aciklama!.isNotEmpty)
              Text(
                f.aciklama!,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            const SizedBox(height: 4),
            Text(
              f.isLab
                  ? l10n.reminderOn(fmt.format(f.planDateOnly))
                  : f.hatirlatmaGunOnce > 0
                      ? l10n.followUpSummary(
                          fmt.format(f.planDateOnly),
                          fmt.format(f.reminderDateOnly),
                        )
                      : fmt.format(f.planDateOnly),
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 0,
          children: [
            IconButton(
              tooltip: l10n.complete,
              onPressed: () => _complete(f),
              icon: const Icon(Icons.check_circle_outline),
            ),
            IconButton(
              tooltip: l10n.delete,
              onPressed: () => _delete(f),
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: l10n.goToPatient,
              onPressed: () => _openPatient(f),
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
    );
  }
}
