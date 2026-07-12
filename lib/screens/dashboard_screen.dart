import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import '../models/follow_up.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../services/session_controller.dart';
import '../widgets/patient_card.dart';
import 'auth_gate.dart';
import 'clinic_members_screen.dart';
import 'follow_ups_screen.dart';
import 'join_requests_screen.dart';
import 'manage_clinics_screen.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.db,
    required this.session,
  });

  final DatabaseService db;
  final SessionController session;

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
  int _followUpAttention = 0;
  String? _followUpError;

  static const _pageSize = DatabaseService.defaultPatientPageSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load(reset: true);
    _loadFollowUpBadge();
  }

  Future<void> _loadFollowUpBadge() async {
    try {
      final results = await Future.wait([
        widget.db.countAttentionFollowUps(),
        widget.db.getOpenFollowUps(),
      ]);
      await NotificationService.instance.syncOpenFollowUps(
        results[1] as List<FollowUp>,
      );
      if (!mounted) return;
      setState(() {
        _followUpAttention = results[0] as int;
        _followUpError = null;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      final friendly = msg.contains('SocketException') ||
              msg.contains('Failed host lookup') ||
              msg.contains('ClientException')
          ? 'İnternet bağlantısı yok veya sunucuya ulaşılamıyor. Takip listesi yüklenemedi.'
          : 'Takipler yüklenemedi. migration_followups.sql çalıştırıldı mı?\n$msg';
      setState(() => _followUpError = friendly);
    }
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

  Future<void> _confirmSignOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış yap'),
        content: const Text('Hesabınızdan çıkmak istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Çıkış'),
          ),
        ],
      ),
    );
    if (ok == true) await widget.session.signOut();
  }

  Future<void> _openJoinRequests() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JoinRequestsScreen(session: widget.session),
      ),
    );
  }

  Future<void> _openManageClinics() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManageClinicsScreen(session: widget.session),
      ),
    );
  }

  Future<void> _openClinicMembers() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClinicMembersScreen(
          db: widget.db,
          session: widget.session,
        ),
      ),
    );
  }

  void _showClinicInfo() {
    final clinic = widget.session.clinic;
    final member = widget.session.member;
    if (clinic == null || member == null) return;
    final memberships = widget.session.memberships;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Kliniklerim',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${member.adSoyad} · ${member.rol.label}',
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...memberships.map((m) {
                    final selected = m.klinikId == clinic.id;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.apartment_outlined,
                        color:
                            selected ? Theme.of(ctx).colorScheme.primary : null,
                      ),
                      title: Text(m.clinic.ad),
                      subtitle: Text('${m.member.rol.label} · ${m.clinic.kod}'),
                      trailing: selected
                          ? IconButton(
                              tooltip: 'Kodu kopyala',
                              onPressed: () =>
                                  copyClinicCode(ctx, m.clinic.kod),
                              icon: const Icon(Icons.copy),
                            )
                          : null,
                      onTap: selected
                          ? null
                          : () async {
                              Navigator.pop(ctx);
                              await widget.session.selectClinic(m.klinikId);
                            },
                    );
                  }),
                  const Divider(height: 28),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.vpn_key_outlined),
                    title: const Text('Aktif klinik kodu'),
                    subtitle: Text(
                      clinic.kod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Kopyala',
                      onPressed: () => copyClinicCode(ctx, clinic.kod),
                      icon: const Icon(Icons.copy),
                    ),
                  ),
                  Text(
                    'Kodu paylaşın; katılan kişi onayınızı bekler. '
                    'Anında üye olmaz.',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                  if (widget.session.isActiveClinicAdmin) ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openJoinRequests();
                      },
                      icon: Badge(
                        isLabelVisible:
                            widget.session.pendingJoinCountForActiveClinic > 0,
                        label: Text(
                          '${widget.session.pendingJoinCountForActiveClinic}',
                        ),
                        child: const Icon(Icons.person_add_alt_1),
                      ),
                      label: Text(
                        widget.session.pendingJoinCountForActiveClinic > 0
                            ? 'Katılım istekleri (${widget.session.pendingJoinCountForActiveClinic})'
                            : 'Katılım istekleri',
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openClinicMembers();
                    },
                    icon: const Icon(Icons.group_outlined),
                    label: const Text('Üyeler'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openManageClinics();
                    },
                    icon: const Icon(Icons.add_business_outlined),
                    label: const Text('Başka klinik ekle / katıl'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmSignOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Çıkış yap'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clinicName = widget.session.clinic?.ad ?? 'Klinik Asistan';

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _showClinicInfo,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    clinicName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more,
                  size: 20,
                  color: scheme.onPrimary.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: _themeTooltip(context),
            onPressed: () => KlinikAsistanApp.of(context)?.cycleThemeMode(),
            icon: Icon(_themeIcon(context)),
          ),
          IconButton(
            tooltip: 'Takipler',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FollowUpsScreen(db: widget.db),
                ),
              );
              await _loadFollowUpBadge();
            },
            icon: Badge(
              isLabelVisible: _followUpAttention > 0,
              label: Text('$_followUpAttention'),
              child: const Icon(Icons.event_note_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Klinikler',
            onPressed: _showClinicInfo,
            icon: Badge(
              isLabelVisible:
                  widget.session.pendingJoinCountForActiveClinic > 0 ||
                      widget.session.hasMultipleClinics,
              label: widget.session.pendingJoinCountForActiveClinic > 0
                  ? Text('${widget.session.pendingJoinCountForActiveClinic}')
                  : null,
              smallSize:
                  widget.session.pendingJoinCountForActiveClinic > 0 ? null : 8,
              child: const Icon(Icons.apartment_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Yeni Hasta',
            onPressed: _showAddPatient,
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_followUpAttention > 0)
            MaterialBanner(
              content: Text(
                '$_followUpAttention takip bugün veya gecikmiş',
              ),
              leading: Icon(Icons.notification_important, color: scheme.error),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FollowUpsScreen(db: widget.db),
                      ),
                    );
                    await _loadFollowUpBadge();
                  },
                  child: const Text('Gör'),
                ),
              ],
            ),
          if (_followUpError != null)
            MaterialBanner(
              content: Text('Takipler yüklenemedi: $_followUpError'),
              leading: Icon(Icons.error_outline, color: scheme.error),
              actions: [
                TextButton(
                  onPressed: _loadFollowUpBadge,
                  child: const Text('Tekrar dene'),
                ),
              ],
            ),
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

  IconData _themeIcon(BuildContext context) {
    final mode = KlinikAsistanApp.of(context)?.themeMode ?? ThemeMode.system;
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      ThemeMode.system => Icons.brightness_auto_outlined,
    };
  }

  String _themeTooltip(BuildContext context) {
    final mode = KlinikAsistanApp.of(context)?.themeMode ?? ThemeMode.system;
    return switch (mode) {
      ThemeMode.light => 'Açık tema (WhatsApp)',
      ThemeMode.dark => 'Koyu tema (WhatsApp)',
      ThemeMode.system => 'Sistem teması',
    };
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
