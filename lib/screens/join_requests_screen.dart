import 'package:flutter/material.dart';

import '../models/clinic.dart';
import '../services/session_controller.dart';

/// Klinik yöneticisi: bekleyen katılım isteklerini onaylar / reddeder.
class JoinRequestsScreen extends StatefulWidget {
  const JoinRequestsScreen({super.key, required this.session});

  final SessionController session;

  @override
  State<JoinRequestsScreen> createState() => _JoinRequestsScreenState();
}

class _JoinRequestsScreenState extends State<JoinRequestsScreen> {
  late Future<List<ClinicJoinRequest>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.session.getPendingJoinRequestsForActiveClinic();
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.session.getPendingJoinRequestsForActiveClinic();
    });
    await _future;
  }

  Future<void> _approve(ClinicJoinRequest r) async {
    try {
      await widget.session.approveJoinRequest(r.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${r.adSoyad} onaylandı')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Onaylanamadı: $e')),
      );
    }
  }

  Future<void> _reject(ClinicJoinRequest r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İsteği reddet'),
        content: Text('${r.adSoyad} isteğini reddetmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reddet'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await widget.session.rejectJoinRequest(r.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${r.adSoyad} reddedildi')),
      );
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reddedilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicName = widget.session.clinic?.ad ?? 'Klinik';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katılım istekleri'),
      ),
      body: FutureBuilder<List<ClinicJoinRequest>>(
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
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    child: Center(
                      child: Text(
                        '$clinicName için bekleyen istek yok.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final r = items[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.adSoyad,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('${r.rol.label} olarak katılmak istiyor'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _reject(r),
                                child: const Text('Reddet'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _approve(r),
                                child: const Text('Onayla'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Kliniği olmayan kullanıcı: bekleyen isteklerini görür.
class PendingJoinScreen extends StatelessWidget {
  const PendingJoinScreen({
    super.key,
    required this.session,
    this.onCreateOrJoin,
  });

  final SessionController session;
  final VoidCallback? onCreateOrJoin;

  @override
  Widget build(BuildContext context) {
    final pending = session.myPendingRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onay bekleniyor'),
        actions: [
          TextButton(
            onPressed: () => session.signOut(),
            child: const Text('Çıkış'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Katılım isteğiniz klinik yöneticisinin onayını bekliyor. '
            'Onaylanınca buradan otomatik geçebilirsiniz.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          ...pending.map(
            (r) => Card(
              child: ListTile(
                leading: const Icon(Icons.hourglass_top),
                title: Text(r.clinic?.ad ?? 'Klinik'),
                subtitle: Text('${r.rol.label} · ${r.durum.label}'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () => session.refreshMembership(),
            icon: const Icon(Icons.refresh),
            label: const Text('Durumu yenile'),
          ),
          if (onCreateOrJoin != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onCreateOrJoin,
              child: const Text('Başka klinik oluştur / katıl'),
            ),
          ],
        ],
      ),
    );
  }
}
