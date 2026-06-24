import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/task_controller.dart';
import '../../models/filter_selection.dart';
import '../../models/task.dart';
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

/// Home / task list screen. Tasks come from [TaskController]; the date/category/
/// search filtering is applied client-side here for an instant UI.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate = _today();
  FilterSelection _filters = const FilterSelection();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Load the user's tasks once the first frame is scheduled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().fetchTasks();
    });
  }

  /// Week strip window: the selected date centered with 3 days on each side.
  List<DateTime> get _week => WeekDateStrip.centeredWeek(around: _selectedDate);

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

  List<Task> _visibleFrom(List<Task> tasks) {
    return tasks.where((Task t) {
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

  Future<void> _toggle(Task task, bool value) async {
    final TaskController controller = context.read<TaskController>();
    final bool ok = await controller.toggleDone(task, value);
    if (!ok && mounted) {
      AppToast.error(
        context,
        controller.consumeActionError() ?? 'Could not update task.',
      );
    }
  }

  Future<void> _delete(Task task) async {
    final TaskController controller = context.read<TaskController>();
    final bool ok = await controller.delete(task);
    if (!mounted) return;
    AppToast.success(context, 'Task deleted');
    if (!ok) {
      AppToast.error(
        context,
        controller.consumeActionError() ?? 'Could not delete task.',
      );
    }
  }

  Future<void> _createTask() async {
    final Task? draft = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => const TaskFormScreen()),
    );
    if (draft == null || !mounted) return;
    final TaskController controller = context.read<TaskController>();
    final bool ok = await controller.create(draft);
    if (!mounted) return;
    if (ok) {
      AppToast.success(context, 'Task created successfully!');
    } else {
      AppToast.error(
        context,
        controller.consumeActionError() ?? 'Could not create task.',
      );
    }
  }

  Future<void> _editTask(Task task) async {
    final Task? updated = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(builder: (_) => TaskFormScreen(initial: task)),
    );
    if (updated == null || !mounted) return;
    final TaskController controller = context.read<TaskController>();
    final bool ok = await controller.update(updated);
    if (!mounted) return;
    if (ok) {
      AppToast.success(context, 'Task updated successfully!');
    } else {
      AppToast.error(
        context,
        controller.consumeActionError() ?? 'Could not update task.',
      );
    }
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
    });
  }

  Future<void> _confirmLogout() async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to see your tasks.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    context.read<TaskController>().reset();
    await context.read<AuthController>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final TaskController controller = context.watch<TaskController>();
    final String userName = context.select<AuthController, String>(
      (AuthController a) => a.user?.name ?? 'there',
    );

    final List<Task> visible = _visibleFrom(controller.tasks);
    final int doneCount = visible.where((Task t) => t.isDone).length;

    final bool initialLoading =
        controller.status == TaskListStatus.loading && controller.tasks.isEmpty;
    final bool loadFailed =
        controller.status == TaskListStatus.error && controller.tasks.isEmpty;

    return Scaffold(
      floatingActionButton: AppFab(onPressed: _createTask),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<TaskController>().fetchTasks(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      Text(userName, style: context.text.headlineSmall),
                    ],
                  ),
                  GestureDetector(
                    onTap: _confirmLogout,
                    child: AppAvatar(name: userName),
                  ),
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
              if (initialLoading)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (loadFailed)
                _LoadError(
                  message: controller.error ?? 'Could not load your tasks.',
                  onRetry: () => context.read<TaskController>().fetchTasks(),
                )
              else if (visible.isEmpty)
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
      ),
    );
  }
}

/// Inline error + retry shown when the initial task load fails.
class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
