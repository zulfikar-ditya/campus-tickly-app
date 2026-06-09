import 'package:flutter/material.dart';

import 'models/filter_selection.dart';
import 'models/task.dart';
import 'models/task_category.dart';
import 'mock/mock_tasks.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'widgets/app_avatar.dart';
import 'widgets/app_checkbox.dart';
import 'widgets/app_fab.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_progress_bar.dart';
import 'widgets/app_switch.dart';
import 'widgets/app_text_field.dart';
import 'widgets/app_toast.dart';
import 'widgets/auth_footer.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/category_tag.dart';
import 'widgets/date_cell.dart';
import 'widgets/date_time_fields.dart';
import 'widgets/empty_state.dart';
import 'widgets/error_banner.dart';
import 'widgets/filter_icon_button.dart';
import 'widgets/filters_sheet.dart';
import 'widgets/password_field.dart';
import 'widgets/picker_field.dart';
import 'widgets/primary_button.dart';
import 'widgets/progress_card.dart';
import 'widgets/search_field.dart';
import 'widgets/section_header.dart';
import 'widgets/selectable_chip.dart';
import 'widgets/task_list.dart';
import 'widgets/text_link.dart';
import 'widgets/week_date_strip.dart';

/// TEMPORARY component gallery — replace with the Sign In screen once screens
/// are built. Exercises every atom/molecule so they can be eyeballed in
/// light and dark mode.
class FoundationPreview extends StatefulWidget {
  const FoundationPreview({super.key});

  @override
  State<FoundationPreview> createState() => _FoundationPreviewState();
}

class _FoundationPreviewState extends State<FoundationPreview> {
  bool _checked = true;
  bool _reminder = true;
  int _selectedChip = 1;
  int _selectedDay = 4;
  TaskCategory? _category = TaskCategory.work;
  List<Task> _tasks = mockTasks();
  final List<DateTime> _week = WeekDateStrip.centeredWeek();
  late DateTime _weekSelected = _week.first;
  FilterSelection _filters = const FilterSelection();

  void _toggleTask(Task task, bool value) {
    setState(() {
      _tasks = <Task>[
        for (final Task t in _tasks)
          t.id == task.id ? t.copyWith(isDone: value) : t,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<String> chips = <String>[
      'All',
      'Today',
      'Yesterday',
      'Last 7 days',
    ];
    final int doneCount = _tasks.where((Task t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(title: const AppLogo()),
      floatingActionButton: AppFab(onPressed: () {}),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: <Widget>[
          _label(context, 'Buttons & links'),
          PrimaryButton(label: 'Primary action', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          const PrimaryButton(label: 'Loading', isLoading: true),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextLink('Forgot password?', onTap: () {}),
          ),

          _label(context, 'Text fields'),
          const AppTextField(
            label: 'Email',
            hint: 'you@email.com',
            prefixIcon: Icons.mail_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          const PasswordField(label: 'Password', hint: 'Enter password'),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Title',
            isRequired: true,
            hint: 'Enter task title',
            errorText: 'Title is required',
          ),

          _label(context, 'Search + filter'),
          Row(
            children: <Widget>[
              const Expanded(child: SearchField()),
              const SizedBox(width: AppSpacing.md),
              FilterIconButton(onTap: () {}),
            ],
          ),

          _label(context, 'Week strip'),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (BuildContext context, int i) => DateCell(
                date: today.add(Duration(days: i)),
                selected: i == _selectedDay,
                onTap: () => setState(() => _selectedDay = i),
              ),
            ),
          ),

          _label(context, 'Progress'),
          AppProgressBar(value: 0.6),

          _label(context, 'Checkbox, tags & chips'),
          Row(
            children: <Widget>[
              AppCheckbox(
                value: _checked,
                onChanged: (bool v) => setState(() => _checked = v),
              ),
              const SizedBox(width: AppSpacing.md),
              const CategoryTag(TaskCategory.work),
              const SizedBox(width: AppSpacing.sm),
              const CategoryTag(TaskCategory.meeting),
              const SizedBox(width: AppSpacing.sm),
              const AppAvatar(name: 'Zulfikar'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: <Widget>[
              for (int i = 0; i < chips.length; i++)
                SelectableChip(
                  label: chips[i],
                  selected: i == _selectedChip,
                  onTap: () => setState(() => _selectedChip = i),
                ),
            ],
          ),

          _label(context, 'Pickers'),
          CategoryDropdown(
            label: 'Category',
            value: _category,
            onChanged: (TaskCategory v) => setState(() => _category = v),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: DateField(
                  label: 'Start date',
                  value: today,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TimeField(
                  label: 'Start time',
                  value: const TimeOfDay(hour: 9, minute: 0),
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const PickerField(placeholder: 'Plain picker field (no label)'),

          _label(context, 'Switch'),
          AppSwitch(
            title: 'Email reminder',
            subtitle: 'Get notified before this task',
            value: _reminder,
            onChanged: (bool v) => setState(() => _reminder = v),
          ),

          _label(context, 'Progress card'),
          ProgressCard(completed: doneCount, total: _tasks.length),

          _label(context, 'Week strip'),
          WeekDateStrip(
            days: _week,
            selectedDate: _weekSelected,
            onSelect: (DateTime d) => setState(() => _weekSelected = d),
          ),

          _label(context, 'Task list'),
          const SectionHeader(title: 'Today', trailing: '5 tasks'),
          const SizedBox(height: AppSpacing.md),
          TaskList(
            tasks: _tasks,
            onToggle: _toggleTask,
            onEdit: (_) {},
            onDelete: (_) {},
          ),

          _label(context, 'Error banner & toasts'),
          const ErrorBanner(
            message: 'Please fix the errors below before submitting.',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: PrimaryButton(
                  label: 'Success toast',
                  onPressed: () =>
                      AppToast.success(context, 'Task created successfully!'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  label: 'Open filters',
                  onPressed: () async {
                    final FilterSelection? result = await showFiltersSheet(
                      context,
                      _filters,
                    );
                    if (result != null) setState(() => _filters = result);
                  },
                ),
              ),
            ],
          ),

          _label(context, 'Empty state'),
          const EmptyState(),

          const SizedBox(height: AppSpacing.xl),
          AuthFooter(
            prompt: "Don't have an account?",
            actionLabel: 'Sign up',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: context.text.labelMedium?.copyWith(
          color: context.colors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
