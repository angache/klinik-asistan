import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/follow_up.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
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
    try {
      await widget.db.completeFollowUp(f.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tamamlandı: ${f.baslik}')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Takipler')),
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
                    Text('Yüklenemedi: ${snap.error}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reload,
                      child: const Text('Tekrar dene'),
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
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Açık takip yok.')),
                ],
              ),
            );
          }

          final overdue = items.where((e) => e.isOverdue).toList();
          final today = items.where((e) => e.isDueToday).toList();
          final upcoming =
              items.where((e) => !e.isOverdue && !e.isDueToday).toList();

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (overdue.isNotEmpty) ...[
                  _sectionTitle(context, 'Geciken', Colors.red),
                  ...overdue.map((f) => _tile(context, f, fmt)),
                  const SizedBox(height: 12),
                ],
                if (today.isNotEmpty) ...[
                  _sectionTitle(
                    context,
                    'Bugün',
                    Theme.of(context).colorScheme.primary,
                  ),
                  ...today.map((f) => _tile(context, f, fmt)),
                  const SizedBox(height: 12),
                ],
                if (upcoming.isNotEmpty) ...[
                  _sectionTitle(context, 'Yaklaşan', null),
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
    final scheme = Theme.of(context).colorScheme;
    final accent = f.isOverdue
        ? scheme.error
        : f.isDueToday
            ? scheme.primary
            : scheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(
          f.hastaAdSoyad ?? 'Hasta',
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
              fmt.format(f.planDateOnly),
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
              tooltip: 'Tamamla',
              onPressed: () => _complete(f),
              icon: const Icon(Icons.check_circle_outline),
            ),
            IconButton(
              tooltip: 'Hastaya git',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PatientDetailScreen(
                      patient: Patient(
                        id: f.hastaId,
                        adSoyad: f.hastaAdSoyad ?? 'Hasta',
                        olusturmaTarihi: DateTime.now(),
                      ),
                      db: widget.db,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
    );
  }
}
