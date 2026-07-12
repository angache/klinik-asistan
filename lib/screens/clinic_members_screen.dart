import 'package:flutter/material.dart';

import '../models/clinic.dart';
import '../services/database_service.dart';
import '../services/session_controller.dart';

class ClinicMembersScreen extends StatefulWidget {
  const ClinicMembersScreen({
    super.key,
    required this.db,
    required this.session,
  });

  final DatabaseService db;
  final SessionController session;

  @override
  State<ClinicMembersScreen> createState() => _ClinicMembersScreenState();
}

class _ClinicMembersScreenState extends State<ClinicMembersScreen> {
  late Future<List<ClinicMember>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.db.getClinicMembers();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.db.getClinicMembers());
    await _future;
  }

  Future<void> _changeRole(ClinicMember m) async {
    if (!widget.session.isActiveClinicAdmin) return;
    if (m.userId == widget.session.user?.id && m.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendi yönetici rolünüzü değiştiremezsiniz')),
      );
      return;
    }

    final rol = await showModalBottomSheet<ClinicRole>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Rol: ${m.adSoyad}'),
            ),
            for (final r in [ClinicRole.admin, ClinicRole.doktor, ClinicRole.asistan])
              ListTile(
                title: Text(r.label),
                trailing: m.rol == r ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, r),
              ),
          ],
        ),
      ),
    );
    if (rol == null || rol == m.rol) return;

    try {
      await widget.db.updateMemberRole(memberId: m.id, rol: rol);
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol güncellenemedi: $e')),
      );
    }
  }

  Future<void> _remove(ClinicMember m) async {
    if (!widget.session.isActiveClinicAdmin &&
        m.userId != widget.session.user?.id) {
      return;
    }
    if (m.userId == widget.session.user?.id && m.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yönetici hesabınızı buradan silemezsiniz'),
        ),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Üyeyi çıkar'),
        content: Text('${m.adSoyad} klinikten çıkarılsın mı?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Çıkar'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await widget.db.removeMember(m.id);
      if (m.userId == widget.session.user?.id) {
        await widget.session.refreshMembership();
        if (mounted) Navigator.pop(context);
        return;
      }
      await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkarılamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.session.isActiveClinicAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('Klinik üyeleri')),
      body: FutureBuilder<List<ClinicMember>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Yüklenemedi: ${snap.error}'));
          }
          final items = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final m = items[i];
                final me = m.userId == widget.session.user?.id;
                return Card(
                  child: ListTile(
                    title: Text(
                      me ? '${m.adSoyad} (siz)' : m.adSoyad,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(m.rol.label),
                    trailing: isAdmin
                        ? PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'rol') _changeRole(m);
                              if (v == 'cikar') _remove(m);
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'rol',
                                child: Text('Rol değiştir'),
                              ),
                              const PopupMenuItem(
                                value: 'cikar',
                                child: Text('Çıkar'),
                              ),
                            ],
                          )
                        : null,
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
