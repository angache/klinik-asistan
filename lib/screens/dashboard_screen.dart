import 'dart:async';

import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../services/database_service.dart';
import '../widgets/patient_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  String _query = '';
  final List<Patient> _patients = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;
  Timer? _debounce;

  static const _pageSize = DatabaseService.defaultPatientPageSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 240) {
      _load(reset: false);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final next = value.trim();
      if (next == _query) return;
      setState(() => _query = next);
      _load(reset: true);
    });
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _hasMore = true;
      });
    } else {
      if (!_hasMore || _loadingMore) return;
      setState(() => _loadingMore = true);
    }

    try {
      final offset = reset ? 0 : _patients.length;
      final page = await widget.db.getPatientsPage(
        query: _query.isEmpty ? null : _query,
        offset: offset,
        limit: _pageSize,
      );

      if (!mounted) return;
      setState(() {
        if (reset) {
          _patients
            ..clear()
            ..addAll(page.items);
        } else {
          _patients.addAll(page.items);
        }
        _hasMore = page.hasMore;
        _loading = false;
        _loadingMore = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = e;
      });
    }
  }

  Future<void> _showAddPatient() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Hasta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Telefon (opsiyonel)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await widget.db.createPatient(
        adSoyad: nameCtrl.text,
        telefon: phoneCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hasta eklendi')),
      );
      await _load(reset: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hasta eklenemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klinik Asistan'),
        actions: [
          IconButton(
            tooltip: 'Yeni Hasta',
            onPressed: _showAddPatient,
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 1,
            color: scheme.surface,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Hasta ara (ad veya telefon)…',
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    ),
                ],
                onChanged: _onSearchChanged,
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(scheme)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPatient,
        icon: const Icon(Icons.person_add),
        label: const Text('Hasta Ekle'),
      ),
    );
  }

  Widget _buildBody(ColorScheme scheme) {
    if (_loading && _patients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _patients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: scheme.error),
              const SizedBox(height: 12),
              Text(
                'Hastalar yüklenemedi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.error),
              ),
              const SizedBox(height: 8),
              Text(
                '$_error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _load(reset: true),
                child: const Text('Tekrar dene'),
              ),
            ],
          ),
        ),
      );
    }

    if (_patients.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 56,
                      color: scheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _query.isEmpty
                          ? 'Henüz hasta yok.\nSağ üstten ekleyin.'
                          : 'Aramanızla eşleşen hasta bulunamadı.',
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

    return RefreshIndicator(
      onRefresh: () => _load(reset: true),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: _patients.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _patients.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return PatientCard(
            patient: _patients[index],
            db: widget.db,
          );
        },
      ),
    );
  }
}
