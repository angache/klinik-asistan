import 'package:flutter/material.dart';

import '../models/clinic_todo.dart';
import '../services/database_service.dart';
import '../widgets/add_clinic_todo_dialog.dart';
import '../widgets/clinic_todo_tile.dart';

class ClinicTodosScreen extends StatefulWidget {
  const ClinicTodosScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<ClinicTodosScreen> createState() => _ClinicTodosScreenState();
}

class _ClinicTodosScreenState extends State<ClinicTodosScreen> {
  late Future<List<ClinicTodo>> _future;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _future = widget.db.getOpenClinicTodos();
  }

  Future<void> _reload() async {
    final next = widget.db.getClinicTodos(completed: _filter == 'completed');
    setState(() {
      _future = next;
    });
    await next;
  }

  Future<void> _add() async {
    final created = await showAddClinicTodoDialog(
      context: context,
      db: widget.db,
    );
    if (created == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Yapılacak eklendi')),
    );
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Yapılacaklar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Ekle'),
      ),
      body: FutureBuilder<List<ClinicTodo>>(
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
                    Text(
                      'Yüklenemedi.\nmigration_klinik_todolar.sql çalıştırıldı mı?\n\n${snap.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.error),
                    ),
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

          final allItems = snap.data ?? [];
          final currentMemberId = widget.db.session.member?.id;
          final items = switch (_filter) {
            'mine' =>
              allItems.where((e) => e.sorumluUyeId == currentMemberId).toList(),
            'urgent' =>
              allItems.where((e) => e.oncelik == TodoPriority.urgent).toList(),
            'today' => allItems.where((e) => e.needsAttention).toList(),
            _ => allItems,
          };
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _filters(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.45,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.checklist_rtl_outlined,
                            size: 56,
                            color: scheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Açık yapılacak yok.\n'
                            'Ekle ile yazı veya sesli not ekleyin.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (_filter == 'completed') {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                children: [
                  _filters(),
                  const SizedBox(height: 12),
                  ...items.map(
                    (t) => ClinicTodoTile(
                      todo: t,
                      db: widget.db,
                      onChanged: _reload,
                    ),
                  ),
                ],
              ),
            );
          }

          final overdue = items.where((e) => e.isOverdue).toList();
          final today = items.where((e) => e.isDueToday).toList();
          final upcoming = items
              .where((e) =>
                  !e.isOverdue && !e.isDueToday && e.planDateOnly != null)
              .toList();
          final undated = items.where((e) => e.planDateOnly == null).toList();

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                _filters(),
                const SizedBox(height: 12),
                Text(
                  'Klinik genel notlar — randevu, dönüş, hatırlatma…',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                if (overdue.isNotEmpty) ...[
                  _sectionTitle(context, 'Geciken', scheme.error),
                  ...overdue.map(
                    (t) => ClinicTodoTile(
                      todo: t,
                      db: widget.db,
                      onChanged: _reload,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (today.isNotEmpty) ...[
                  _sectionTitle(context, 'Bugün', scheme.primary),
                  ...today.map(
                    (t) => ClinicTodoTile(
                      todo: t,
                      db: widget.db,
                      onChanged: _reload,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (upcoming.isNotEmpty) ...[
                  _sectionTitle(context, 'Yaklaşan', null),
                  ...upcoming.map(
                    (t) => ClinicTodoTile(
                      todo: t,
                      db: widget.db,
                      onChanged: _reload,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (undated.isNotEmpty) ...[
                  _sectionTitle(context, 'Tarihsiz', null),
                  ...undated.map(
                    (t) => ClinicTodoTile(
                      todo: t,
                      db: widget.db,
                      onChanged: _reload,
                    ),
                  ),
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

  Widget _filters() {
    const options = [
      ('all', 'Tümü'),
      ('mine', 'Bana atanan'),
      ('today', 'Bugün/geciken'),
      ('urgent', 'Acil'),
      ('completed', 'Tamamlanan'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final option in options)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(option.$2),
                selected: _filter == option.$1,
                onSelected: (_) {
                  setState(() {
                    _filter = option.$1;
                    _future = widget.db.getClinicTodos(
                      completed: _filter == 'completed',
                    );
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
