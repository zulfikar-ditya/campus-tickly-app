import 'package:flutter/material.dart';

import 'models/task_category.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'widgets/app_avatar.dart';
import 'widgets/app_checkbox.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_progress_bar.dart';
import 'widgets/app_switch.dart';
import 'widgets/app_text_field.dart';
import 'widgets/auth_footer.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/category_tag.dart';
import 'widgets/date_cell.dart';
import 'widgets/date_time_fields.dart';
import 'widgets/filter_icon_button.dart';
import 'widgets/password_field.dart';
import 'widgets/picker_field.dart';
import 'widgets/primary_button.dart';
import 'widgets/search_field.dart';
import 'widgets/section_header.dart';
import 'widgets/selectable_chip.dart';
import 'widgets/text_link.dart';

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

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<String> chips = <String>['All', 'Today', 'Yesterday', 'Last 7 days'];

    return Scaffold(
      appBar: AppBar(title: const AppLogo()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
                child: DateField(label: 'Start date', value: today, onTap: () {}),
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

          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Today', trailing: '5 tasks'),

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
