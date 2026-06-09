import 'package:flutter/material.dart';

import '../../models/filter_selection.dart';
import '../../models/task.dart';
import '../../mock/mock_tasks.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_fab.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_icon_button.dart';
import '../../widgets/filters_sheet.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/task_list.dart';
import '../../widgets/week_date_strip.dart';
import 'task_form_screen.dart';

/// Home / task list screen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _userName = 'Zulfikar';

  List<Task> _tasks = mockTasks();
  late DateTime _selectedDate = _today();

  /// Week strip window: the selected date centered with 3 days on each side.
  List<DateTime> get _week => WeekDateStrip.centeredWeek(around: _selectedDate);
  FilterSelection _filters = const FilterSelection();
  String _query = '';

  static DateTime _today() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String get _greeting {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  bool _matchesDate(Task task) {
    final DateTime now = _today();
    switch (_filters.dateRange) {
      case DateRangeFilter.all:
        return _sameDay(task.start, _selectedDate);
      case DateRangeFilter.today:
        return _sameDay(task.start, now);
      case DateRangeFilter.yesterday:
        return _sameDay(task.start, now.subtract(const Duration(days: 1)));
      case DateRangeFilter.last7Days:
        final DateTime from = now.subtract(const Duration(days: 6));
        final DateTime start = DateTime(
          task.start.year,
          task.start.month,
          task.start.day,
        );
        return !start.isBefore(from) && !start.isAfter(now);
      case DateRangeFilter.custom:
        return _filters.customDate != null &&
            _sameDay(task.start, _filters.customDate!);
    }
  }

  List<Task> get _visibleTasks {
    return _tasks.where((Task t) {
      final bool dateOk = _matchesDate(t);
      final bool categoryOk =
          _filters.category == null || t.category == _filters.category;
      final bool queryOk =
          _query.trim().isEmpty ||
          t.title.toLowerCase().contains(_query.trim().toLowerCase());
      return dateOk && categoryOk && queryOk;
    }).toList();
  }

  String get _listTitle {
    switch (_filters.dateRange) {
      case DateRangeFilter.all:
        return _sameDay(_selectedDate, _today())
            ? 'Today'
            : formatDate(_selectedDate);
      case DateRangeFilter.custom:
        return formatDate(_filters.customDate ?? _selectedDate);
      case DateRangeFilter.today:
      case DateRangeFilter.yesterday:
      case DateRangeFilter.last7Days:
        return _filters.dateRange.label;
    }
  }

  void _toggle(Task task, bool value) {
    setState(() {
      _tasks = <Task>[
        for (final Task t in _tasks)
          t.id == task.id ? t.copyWith(isDone: value) : t,
      ];
    });
  }

  void _delete(Task task) {
    setState(() => _tasks = _tasks.where((Task t) => t.id != task.id).toList());
    AppToast.success(context, 'Task deleted');
  }

  Future<void> _openFilters() async {
    final FilterSelection? result = await showFiltersSheet(context, _filters);
    if (result == null) return;
    setState(() {
      _filters = result;
      // Keep the week strip / header in sync with the chosen date filter.
      final DateTime now = _today();
      switch (result.dateRange) {
        case DateRangeFilter.all:
          break;
        case DateRangeFilter.today:
        case DateRangeFilter.last7Days:
          _selectedDate = now;
        case DateRangeFilter.yesterday:
          _selectedDate = now.subtract(const Duration(days: 1));
        case DateRangeFilter.custom:
          if (result.customDate != null) {
            final DateTime d = result.customDate!;
            _selectedDate = DateTime(d.year, d.month, d.day);
          }
      }
      // The week strip re-centers on _selectedDate automatically (see _week).
    });
  }

  Future<void> _createTask() async {
    final Task? task = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => const TaskFormScreen()),
    );
    if (task == null) return;
    setState(() => _tasks = <Task>[..._tasks, task]);
    if (mounted) AppToast.success(context, 'Task created successfully!');
  }

  Future<void> _editTask(Task task) async {
    final Task? updated = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => TaskFormScreen(initial: task)),
    );
    if (updated == null) return;
    setState(() {
      _tasks = <Task>[
        for (final Task t in _tasks) t.id == updated.id ? updated : t,
      ];
    });
    if (mounted) AppToast.success(context, 'Task updated successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final List<Task> visible = _visibleTasks;
    final int doneCount = visible.where((Task t) => t.isDone).length;

    return Scaffold(
      floatingActionButton: AppFab(onPressed: _createTask),
      body: SafeArea(
        child: ListView(
          // Extra bottom padding so the last row's actions clear the FAB.
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.screen,
            AppSpacing.screen,
            96,
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _greeting,
                      style: context.text.bodyMedium?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                    Text(_userName, style: context.text.headlineSmall),
                  ],
                ),
                const AppAvatar(name: _userName),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ProgressCard(completed: doneCount, total: visible.length),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: SearchField(
                    onChanged: (String v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                FilterIconButton(onTap: _openFilters),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            WeekDateStrip(
              days: _week,
              selectedDate: _selectedDate,
              onSelect: (DateTime d) => setState(() {
                _selectedDate = d;
                // Selecting a day clears any explicit date-range filter.
                _filters = _filters.copyWith(
                  dateRange: DateRangeFilter.all,
                  clearCustomDate: true,
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: _listTitle,
              trailing:
                  '${visible.length} '
                  '${visible.length == 1 ? 'task' : 'tasks'}',
            ),
            const SizedBox(height: AppSpacing.md),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.xl),
                child: EmptyState(),
              )
            else
              TaskList(
                tasks: visible,
                onToggle: _toggle,
                onEdit: _editTask,
                onDelete: _delete,
              ),
          ],
        ),
      ),
    );
  }
}
