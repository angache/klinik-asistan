import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/treatment_templates.dart';
import '../l10n/l10n.dart';
import '../models/clinic_report.dart';
import '../services/database_service.dart';
import 'patient_detail_screen.dart';
import 'recall_screen.dart';
import 'settings_screen.dart' show openExternalUrl;

enum _PeriodKind {
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  custom;

  String get label => switch (this) {
        _PeriodKind.thisWeek => currentL10n.periodThisWeek,
        _PeriodKind.lastWeek => currentL10n.periodLastWeek,
        _PeriodKind.thisMonth => currentL10n.periodThisMonth,
        _PeriodKind.lastMonth => currentL10n.periodLastMonth,
        _PeriodKind.custom => currentL10n.pickDate,
      };
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, required this.db});

  final DatabaseService db;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const _stalledOptions = [30, 60, 90];

  _PeriodKind _kind = _PeriodKind.thisWeek;
  late ReportPeriod _period = ReportPeriod.thisWeek(DateTime.now());
  int _stalledDays = 30;
  int _refreshToken = 0;
  late Future<ClinicReport> _future = _load();

  Future<ClinicReport> _load() =>
      widget.db.getClinicReport(_period, stalledDays: _stalledDays);

  Future<void> _reload() async {
    setState(() {
      _future = _load();
      _refreshToken++;
    });
    try {
      await _future;
    } catch (_) {}
  }

  Future<void> _selectKind(_PeriodKind kind) async {
    final now = DateTime.now();
    ReportPeriod? period;
    switch (kind) {
      case _PeriodKind.thisWeek:
        period = ReportPeriod.thisWeek(now);
      case _PeriodKind.lastWeek:
        period = ReportPeriod.lastWeek(now);
      case _PeriodKind.thisMonth:
        period = ReportPeriod.thisMonth(now);
      case _PeriodKind.lastMonth:
        period = ReportPeriod.lastMonth(now);
      case _PeriodKind.custom:
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 5),
          lastDate: now,
          initialDateRange: DateTimeRange(
            start: _period.start,
            end: _period.end.subtract(const Duration(days: 1)),
          ),
          helpText: context.l10n.reportPeriod,
          saveText: context.l10n.apply,
        );
        if (range == null) return;
        period = ReportPeriod.custom(range.start, range.end);
    }
    _kind = kind;
    _period = period;
    await _reload();
  }

  Future<void> _openPatient(String id) async {
    try {
      final patient = await widget.db.getPatient(id);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PatientDetailScreen(patient: patient, db: widget.db),
        ),
      );
      if (mounted) await _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.patientOpenFailed(errorText(e)))),
      );
    }
  }

  String _rangeText(DateTime start, DateTime endExclusive) {
    final last = endExclusive.subtract(const Duration(days: 1));
    final full = DateFormat.yMMMd();
    if (start == last) return full.format(start);
    final sameYear = start.year == last.year;
    final first = sameYear ? DateFormat.MMMd() : DateFormat.yMMMd();
    return '${first.format(start)} – ${full.format(last)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<ClinicReport>(
          future: _future,
          builder: (context, snap) {
            final children = <Widget>[
              _periodSelector(context),
              const SizedBox(height: 12),
            ];
            if (snap.connectionState != ConnectionState.done) {
              children.add(const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ));
            } else if (snap.hasError) {
              children.add(_ErrorBox(error: snap.error, onRetry: _reload));
            } else {
              children.addAll(_reportSections(context, snap.data!));
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
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

  Widget _periodSelector(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final k in _PeriodKind.values)
              ChoiceChip(
                label: Text(k.label),
                avatar: k == _PeriodKind.custom
                    ? const Icon(Icons.date_range, size: 18)
                    : null,
                selected: _kind == k,
                onSelected: (_) => _selectKind(k),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _rangeText(_period.start, _period.end),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          context.l10n.comparedWith(
            _rangeText(_period.previousStart, _period.previousEnd),
          ),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  List<Widget> _reportSections(BuildContext context, ClinicReport r) {
    final l10n = context.l10n;
    return [
      _SummaryGrid(report: r),
      const SizedBox(height: 16),
      _Section(
        title: l10n.topProcedures,
        icon: Icons.leaderboard_outlined,
        child: r.topProcedures.isEmpty
            ? _EmptyText(l10n.noProceduresInPeriod)
            : _BarList(
                items: [
                  for (final p in r.topProcedures)
                    ReportCount(procedureLabel(p.label), p.count),
                ],
              ),
      ),
      if (r.categories.length > 1) ...[
        const SizedBox(height: 16),
        _Section(
          title: l10n.byCategory,
          icon: Icons.category_outlined,
          child: _BarList(
            items: [
              for (final c in r.categories)
                ReportCount(categoryLabel(c.label), c.count),
            ],
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
      const SizedBox(height: 16),
      _Section(
        title: l10n.dailyActivity,
        icon: Icons.bar_chart,
        child: _DailyChart(report: r, period: _period),
      ),
      const SizedBox(height: 16),
      _Section(
        title: l10n.followUpStatus,
        icon: Icons.event_note_outlined,
        child: _FollowUpStatus(report: r),
      ),
      const SizedBox(height: 16),
      _Section(
        title: l10n.patientsToRecall,
        icon: Icons.phone_callback_outlined,
        trailing: DropdownButton<int>(
          value: _stalledDays,
          underline: const SizedBox.shrink(),
          items: [
            for (final d in _stalledOptions)
              DropdownMenuItem(value: d, child: Text(l10n.daysPlus(d))),
          ],
          onChanged: (v) {
            if (v == null || v == _stalledDays) return;
            _stalledDays = v;
            _reload();
          },
        ),
        child: _StalledPatients(
          patients: r.stalledPatients,
          days: _stalledDays,
          onOpen: (p) => _openPatient(p.id),
        ),
      ),
      const SizedBox(height: 16),
      _RecallSummary(
        db: widget.db,
        refreshToken: _refreshToken,
        onOpen: _openRecalls,
      ),
    ];
  }

  Future<void> _openRecalls() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecallScreen(db: widget.db)),
    );
    if (mounted) await _reload();
  }
}

class _RecallSummary extends StatefulWidget {
  const _RecallSummary({
    required this.db,
    required this.refreshToken,
    required this.onOpen,
  });

  final DatabaseService db;
  final int refreshToken;
  final VoidCallback onOpen;

  @override
  State<_RecallSummary> createState() => _RecallSummaryState();
}

class _RecallSummaryState extends State<_RecallSummary> {
  late Future<RecallList> _future = _load();

  Future<RecallList> _load() => widget.db.getRecallPatients(limit: 0);

  @override
  void didUpdateWidget(covariant _RecallSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return _Section(
      title: l10n.recalls,
      icon: Icons.event_repeat_outlined,
      child: FutureBuilder<RecallList>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.hasError) {
            return Text(
              l10n.loadFailed(errorText(snap.error)),
              style: TextStyle(color: scheme.error),
            );
          }
          final list = snap.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                list.total == 0
                    ? l10n.noRecallsDue
                    : l10n.recallsWaiting(list.total),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (list.oldTotal > 0)
                _EmptyText(l10n.oldRecallsCount(list.oldTotal)),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: widget.onOpen,
                  icon: const Icon(Icons.list_alt_outlined),
                  label: Text(l10n.openList),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _call(BuildContext context, String phone) => openExternalUrl(
      context,
      'tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}',
    );

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.report});

  final ClinicReport report;

  @override
  Widget build(BuildContext context) {
    final r = report;
    final l10n = context.l10n;
    final tiles = [
      _StatTile(
        label: l10n.statProceduresDone,
        value: r.count('yapilan_islem'),
        previous: r.count('yapilan_islem_onceki'),
        icon: Icons.medical_services_outlined,
        hint: l10n.statProceduresHint,
      ),
      _StatTile(
        label: l10n.statPatientsTreated,
        value: r.count('tedavi_goren_hasta'),
        previous: r.count('tedavi_goren_hasta_onceki'),
        icon: Icons.people_alt_outlined,
      ),
      _StatTile(
        label: l10n.statVisits,
        value: r.count('hasta_ziyareti'),
        previous: r.count('hasta_ziyareti_onceki'),
        icon: Icons.event_available_outlined,
        hint: l10n.statVisitsHint,
      ),
      _StatTile(
        label: l10n.statNewPatients,
        value: r.count('yeni_hasta'),
        previous: r.count('yeni_hasta_onceki'),
        icon: Icons.person_add_alt_1_outlined,
      ),
      _StatTile(
        label: l10n.statTotalPatients,
        value: r.count('toplam_hasta'),
        icon: Icons.folder_shared_outlined,
      ),
      _StatTile(
        label: l10n.statPendingPlanned,
        value: r.count('planlanan_bekleyen'),
        icon: Icons.pending_actions_outlined,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 3 : 2;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final t in tiles) SizedBox(width: width, child: t),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.previous,
    this.hint,
  });

  final String label;
  final int value;
  final int? previous;
  final IconData icon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tile = Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (previous != null) _Delta(current: value, previous: previous!),
          ],
        ),
      ),
    );
    return hint == null ? tile : Tooltip(message: hint!, child: tile);
  }
}

class _Delta extends StatelessWidget {
  const _Delta({required this.current, required this.previous});

  final int current;
  final int previous;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final diff = current - previous;
    final String text;
    final Color color;
    final IconData icon;
    if (diff == 0) {
      text = context.l10n.sameAsPrevious;
      color = scheme.onSurfaceVariant;
      icon = Icons.remove;
    } else {
      final percent = previous == 0
          ? ''
          : ' (${NumberFormat.percentPattern().format(diff.abs() / previous)})';
      text = '${diff > 0 ? '+' : '−'}${diff.abs()}$percent';
      color = diff > 0 ? Colors.green.shade700 : scheme.error;
      icon = diff > 0 ? Icons.trending_up : Icons.trending_down;
    }
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _BarList extends StatelessWidget {
  const _BarList({required this.items, this.color});

  final List<ReportCount> items;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final max = items.fold<int>(0, (m, e) => e.count > m ? e.count : m);
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${item.count}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: max == 0 ? 0 : item.count / max,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: color ?? scheme.primary,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DailyChart extends StatelessWidget {
  const _DailyChart({required this.report, required this.period});

  final ClinicReport report;
  final ReportPeriod period;

  /// 1 Ocak 2024 Pazartesi; [weekday] 1–7 için o haftanın günü.
  static DateTime _weekdayDate(int weekday) => DateTime(2024, 1, weekday);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final daily = report.dailySeries(period);
    if (daily.every((e) => e.$2 == 0)) {
      return _EmptyText(l10n.noProceduresInPeriod);
    }

    // Uzun dönemlerde haftalık toplam gösterilir.
    final weekly = daily.length > 31;
    final dayFmt = DateFormat.MMMd();
    final weekdayFmt = DateFormat.E();
    final bars = <(String, String, int)>[]; // (eksen etiketi, ipucu, adet)
    if (weekly) {
      for (var i = 0; i < daily.length; i += 7) {
        final chunk =
            daily.sublist(i, i + 7 > daily.length ? daily.length : i + 7);
        final total = chunk.fold<int>(0, (s, e) => s + e.$2);
        final label = dayFmt.format(chunk.first.$1);
        bars.add((
          label,
          '${l10n.weekOf(label)}: ${l10n.procedureCount(total)}',
          total,
        ));
      }
    } else {
      for (final (d, c) in daily) {
        final label = daily.length <= 7 ? weekdayFmt.format(d) : '${d.day}';
        bars.add((label, '${dayFmt.format(d)}: ${l10n.procedureCount(c)}', c));
      }
    }
    final max = bars.fold<int>(1, (m, e) => e.$3 > m ? e.$3 : m);
    final labelEvery = bars.length <= 10 ? 1 : (bars.length / 8).ceil();
    const chartHeight = 140.0;

    final weekdayTotals = report.weekdayTotals();
    final busiest =
        weekdayTotals.entries.reduce((a, b) => b.value > a.value ? b : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: chartHeight + 36,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < bars.length; i++)
                Expanded(
                  child: Tooltip(
                    message: bars[i].$2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: bars.length > 20 ? 1 : 3,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (bars.length <= 14 && bars[i].$3 > 0)
                            Text(
                              '${bars[i].$3}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          const SizedBox(height: 2),
                          Container(
                            height: bars[i].$3 == 0
                                ? 2
                                : chartHeight * bars[i].$3 / max,
                            decoration: BoxDecoration(
                              color: bars[i].$3 == 0
                                  ? scheme.surfaceContainerHighest
                                  : scheme.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 14,
                            child: i % labelEvery == 0
                                ? Text(
                                    bars[i].$1,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (period.dayCount >= 7 && busiest.value > 0) ...[
          const SizedBox(height: 8),
          Text(
            l10n.busiestDay(
              DateFormat.EEEE().format(_weekdayDate(busiest.key)),
              l10n.procedureCount(busiest.value),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _FollowUpStatus extends StatelessWidget {
  const _FollowUpStatus({required this.report});

  final ClinicReport report;

  @override
  Widget build(BuildContext context) {
    final r = report;
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    Widget row(IconData icon, String label, int open, int overdue) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Icon(icon, color: scheme.primary),
        title: Text(label),
        subtitle: overdue > 0
            ? Text(
                l10n.overdueCount(overdue),
                style: TextStyle(color: scheme.error),
              )
            : null,
        trailing: Text(
          '$open',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(
          Icons.science_outlined,
          l10n.labPending,
          r.followUp('lab_bekleyen'),
          r.followUp('lab_geciken'),
        ),
        row(
          Icons.event_repeat_outlined,
          l10n.controlPending,
          r.followUp('kontrol_bekleyen'),
          r.followUp('kontrol_geciken'),
        ),
        row(
          Icons.checklist_rtl_outlined,
          l10n.openTasks,
          r.followUp('gorev_acik'),
          r.followUp('gorev_geciken'),
        ),
        const Divider(),
        Text(
          l10n.completedInPeriod(
            r.followUp('lab_tamamlanan'),
            r.followUp('kontrol_tamamlanan'),
            r.followUp('gorev_tamamlanan'),
          ),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StalledPatients extends StatelessWidget {
  const _StalledPatients({
    required this.patients,
    required this.days,
    required this.onOpen,
  });

  final List<StalledPatient> patients;
  final int days;
  final ValueChanged<StalledPatient> onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final fmt = DateFormat.yMMMd();
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.stalledHint(days),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        if (patients.isEmpty)
          _EmptyText(l10n.noPatientsToRecall)
        else ...[
          for (final p in patients)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => onOpen(p),
              title: Text(p.adSoyad),
              subtitle: Text(
                [
                  if (p.sonIslemTarihi != null)
                    l10n.lastProcedure(
                      fmt.format(p.sonIslemTarihi!),
                      now.difference(p.sonIslemTarihi!).inDays,
                    )
                  else
                    l10n.noProceduresYet,
                  l10n.plannedList(p.planlanan.map(procedureLabel).join(', ')),
                ].join('\n'),
              ),
              isThreeLine: true,
              trailing: (p.telefon ?? '').trim().isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.callPhone(p.telefon!),
                      icon: const Icon(Icons.call_outlined),
                      onPressed: () => _call(context, p.telefon!),
                    ),
            ),
          if (patients.length >= 100) _EmptyText(l10n.firstNPatients(100)),
        ],
      ],
    );
  }
}
