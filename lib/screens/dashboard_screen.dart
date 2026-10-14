import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../main.dart';
import '../models/follow_up.dart';
import '../models/patient.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/session_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/patient_card.dart';
import 'auth_gate.dart';
import 'clinic_todos_screen.dart';
import 'clinic_members_screen.dart';
import 'follow_ups_screen.dart';
import 'join_requests_screen.dart';
import 'manage_clinics_screen.dart';
import 'patient_detail_screen.dart';
import 'recall_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'treatment_templates_screen.dart';

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
  int _todoAttention = 0;
  int _recallCount = 0;
  String? _followUpError;
  Patient? _selectedPatient;
  PatientListSort _sort = PatientListSort.lastVisit;

  static const _pageSize = DatabaseService.defaultPatientPageSize;
  static const _wideBreakpoint = 1000.0;
  static const _sortPrefKey = 'patient_list_sort';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _restoreSortAndLoad();
    _loadFollowUpBadge();
  }

  Future<void> _restoreSortAndLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_sortPrefKey);
      if (raw == PatientListSort.name.name) {
        _sort = PatientListSort.name;
      } else {
        _sort = PatientListSort.lastVisit;
      }
    } catch (_) {}
    if (!mounted) return;
    await _load(reset: true);
  }

  Future<void> _setSort(PatientListSort sort) async {
    if (sort == _sort) return;
    setState(() => _sort = sort);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sortPrefKey, sort.name);
    } catch (_) {}
    await _load(reset: true);
  }

  /// 027 çalıştırılmamışsa ya da bağlantı yoksa rozet sessizce gizlenir.
  Future<void> _loadRecallBadge() async {
    try {
      final count = await widget.db.countRecallPatients();
      if (mounted) setState(() => _recallCount = count);
    } catch (_) {
      if (mounted) setState(() => _recallCount = 0);
    }
  }

  Future<void> _loadFollowUpBadge() async {
    unawaited(_loadRecallBadge());
    try {
      final results = await Future.wait([
        widget.db.countAttentionFollowUps(),
        widget.db.getOpenFollowUps(),
        widget.db.countAttentionClinicTodos(),
      ]);
      await NotificationService.instance.syncOpenFollowUps(
        results[1] as List<FollowUp>,
      );
      if (!mounted) return;
      setState(() {
        _followUpAttention = results[0] as int;
        _todoAttention = results[2] as int;
        _followUpError = null;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      final friendly = msg.contains('SocketException') ||
              msg.contains('Failed host lookup') ||
              msg.contains('ClientException')
          ? context.l10n.followUpsOffline
          : context.l10n.followUpsLoadFailed(msg);
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
        sort: _sort,
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

    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newPatient),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.fullNameLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l10n.phoneOptionalLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.add),
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
        SnackBar(content: Text(l10n.patientAdded)),
      );
      await _load(reset: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.patientAddFailed(errorText(e)))),
      );
    }
  }

  Future<void> _confirmSignOut() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutTitle),
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
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

  Future<void> _openReports() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReportsScreen(db: widget.db)),
    );
    await _loadRecallBadge();
  }

  Future<void> _openRecalls() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecallScreen(db: widget.db)),
    );
    await _loadFollowUpBadge();
  }

  Future<void> _openTreatmentTemplates() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TreatmentTemplatesScreen(db: widget.db),
      ),
    );
  }

  void _showClinicInfo() {
    final clinic = widget.session.clinic;
    final member = widget.session.member;
    if (clinic == null || member == null) return;
    final memberships = widget.session.memberships;
    final l10n = context.l10n;
    final pendingJoins = widget.session.pendingJoinCountForActiveClinic;

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
                    l10n.myClinics,
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
                              tooltip: l10n.copyCode,
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
                    title: Text(l10n.activeClinicCode),
                    subtitle: Text(
                      clinic.kod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: l10n.copy,
                      onPressed: () => copyClinicCode(ctx, clinic.kod),
                      icon: const Icon(Icons.copy),
                    ),
                  ),
                  Text(
                    l10n.clinicCodeShareHint,
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
                        isLabelVisible: pendingJoins > 0,
                        label: Text('$pendingJoins'),
                        child: const Icon(Icons.person_add_alt_1),
                      ),
                      label: Text(
                        pendingJoins > 0
                            ? l10n.joinRequestsCount(pendingJoins)
                            : l10n.joinRequests,
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
                    label: Text(l10n.members),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openReports();
                    },
                    icon: const Icon(Icons.insights_outlined),
                    label: Text(l10n.reports),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAppearanceSheet(context);
                    },
                    icon: Icon(_themeIcon(context)),
                    label: Text(l10n.appearance),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openTreatmentTemplates();
                    },
                    icon: const Icon(Icons.medical_services_outlined),
                    label: Text(l10n.treatmentTemplates),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openManageClinics();
                    },
                    icon: const Icon(Icons.add_business_outlined),
                    label: Text(l10n.addOrJoinClinic),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SettingsScreen(session: widget.session),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                    label: Text(l10n.settingsAndAccount),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmSignOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.signOutTitle),
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
    final l10n = context.l10n;
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
                  color: (Theme.of(context).appBarTheme.foregroundColor ??
                          scheme.onPrimary)
                      .withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.recalls,
            onPressed: _openRecalls,
            icon: Badge(
              isLabelVisible: _recallCount > 0,
              label: Text('$_recallCount'),
              child: const Icon(Icons.event_repeat_outlined),
            ),
          ),
          IconButton(
            tooltip: l10n.todos,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ClinicTodosScreen(db: widget.db),
                ),
              );
              await _loadFollowUpBadge();
            },
            icon: Badge(
              isLabelVisible: _todoAttention > 0,
              label: Text('$_todoAttention'),
              child: const Icon(Icons.checklist_rtl_outlined),
            ),
          ),
          IconButton(
            tooltip: l10n.followUps,
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
            tooltip: l10n.reports,
            onPressed: _openReports,
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            tooltip: l10n.clinics,
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
            tooltip: l10n.newPatient,
            onPressed: _showAddPatient,
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= _wideBreakpoint;
          final listPane = Column(
            children: [
              if (_followUpAttention > 0)
                MaterialBanner(
                  content: Text(l10n.followUpsDue(_followUpAttention)),
                  leading:
                      Icon(Icons.notification_important, color: scheme.error),
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
                      child: Text(l10n.view),
                    ),
                  ],
                ),
              if (_followUpError != null)
                MaterialBanner(
                  content: Text(_followUpError!),
                  leading: Icon(Icons.error_outline, color: scheme.error),
                  actions: [
                    TextButton(
                      onPressed: _loadFollowUpBadge,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              Material(
                elevation: 1,
                color: scheme.surface,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SearchBar(
                        controller: _searchController,
                        hintText: l10n.searchPatientsHint,
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
                      const SizedBox(height: 10),
                      SegmentedButton<PatientListSort>(
                        segments: [
                          ButtonSegment(
                            value: PatientListSort.name,
                            label: Text(l10n.sortByName),
                            icon: const Icon(Icons.sort_by_alpha, size: 18),
                          ),
                          ButtonSegment(
                            value: PatientListSort.lastVisit,
                            label: Text(l10n.sortByLastVisit),
                            icon: const Icon(Icons.schedule, size: 18),
                          ),
                        ],
                        selected: {_sort},
                        onSelectionChanged: (s) {
                          if (s.isEmpty) return;
                          _setSort(s.first);
                        },
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          textStyle: WidgetStatePropertyAll(
                            Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: _buildBody(scheme, wide: wide)),
            ],
          );

          if (!wide) return listPane;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: (constraints.maxWidth * 0.36).clamp(320.0, 440.0),
                child: listPane,
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: scheme.outlineVariant,
              ),
              Expanded(
                child: _selectedPatient == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_search_outlined,
                              size: 56,
                              color: scheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.selectPatientHint,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : PatientDetailScreen(
                        key: ValueKey(_selectedPatient!.id),
                        patient: _selectedPatient!,
                        db: widget.db,
                        embedded: true,
                        onClose: () {
                          setState(() => _selectedPatient = null);
                          _load(reset: true);
                          _loadFollowUpBadge();
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPatient,
        icon: const Icon(Icons.person_add),
        label: Text(l10n.addPatient),
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

  Future<void> _showAppearanceSheet(BuildContext context) async {
    final app = KlinikAsistanApp.of(context);
    if (app == null) return;
    final l10n = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.appearance,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.themeLabel,
                  style: Theme.of(ctx).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.themeLight),
                      icon: const Icon(Icons.light_mode_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.themeDark),
                      icon: const Icon(Icons.dark_mode_outlined, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.themeSystem),
                      icon:
                          const Icon(Icons.brightness_auto_outlined, size: 18),
                    ),
                  ],
                  selected: {app.themeMode},
                  onSelectionChanged: (s) {
                    if (s.isEmpty) return;
                    app.setThemeMode(s.first);
                    Navigator.pop(ctx);
                  },
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.colorPalette,
                  style: Theme.of(ctx).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                ...AppColorPalette.values.map((p) {
                  final selected = app.palette == p;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      selected: selected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected
                              ? Theme.of(ctx).colorScheme.primary
                              : Theme.of(ctx).colorScheme.outlineVariant,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: p.previewColor,
                        radius: 14,
                      ),
                      title: Text(p.label),
                      subtitle: Text(p.description),
                      trailing: selected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(ctx).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        app.setPalette(p);
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ColorScheme scheme, {required bool wide}) {
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
                context.l10n.patientsLoadFailed,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.error),
              ),
              const SizedBox(height: 8),
              Text(
                errorText(_error),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _load(reset: true),
                child: Text(context.l10n.retry),
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
                          ? context.l10n.noPatientsYet
                          : context.l10n.noPatientsMatch,
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
          final patient = _patients[index];
          return PatientCard(
            patient: patient,
            db: widget.db,
            selected: wide && _selectedPatient?.id == patient.id,
            onOpen:
                wide ? () => setState(() => _selectedPatient = patient) : null,
          );
        },
      ),
    );
  }
}
