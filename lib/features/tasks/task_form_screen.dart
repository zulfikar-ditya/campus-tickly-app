import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../models/task_category.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_switch.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/category_dropdown.dart';
import '../../widgets/date_time_fields.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/primary_button.dart';

/// Create or edit a task. Pass [initial] to edit an existing task; omit it to
/// create a new one. Returns the resulting [Task] via `Navigator.pop`.
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.initial});

  final Task? initial;

  bool get isEditing => initial != null;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  TaskCategory? _category;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _emailReminder = false;

  bool _showBanner = false;
  String? _titleError;
  String? _categoryError;
  String? _startDateError;
  String? _endDateError;

  @override
  void initState() {
    super.initState();
    final Task? t = widget.initial;
    _title = TextEditingController(text: t?.title ?? '');
    _description = TextEditingController(text: t?.description ?? '');
    _category = t?.category;
    _startDate = t == null ? null : DateTime(t.start.year, t.start.month, t.start.day);
    _endDate = t == null ? null : DateTime(t.end.year, t.end.month, t.end.day);
    _startTime = t == null ? null : TimeOfDay.fromDateTime(t.start);
    _endTime = t == null ? null : TimeOfDay.fromDateTime(t.end);
    _emailReminder = t?.emailReminder ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime initial = (isStart ? _startDate : _endDate) ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateError = null;
        } else {
          _endDate = picked;
          _endDateError = null;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final TimeOfDay initial =
        (isStart ? _startTime : _endTime) ?? TimeOfDay.now();
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submit() {
    setState(() {
      _titleError =
          _title.text.trim().isEmpty ? 'Title is required' : null;
      _categoryError = _category == null ? 'Category is required' : null;
      _startDateError = _startDate == null ? 'Start date is required' : null;
      if (_endDate == null) {
        _endDateError = 'End date is required';
      } else if (_startDate != null && _endDate!.isBefore(_startDate!)) {
        _endDateError = 'End date must be after start date';
      } else {
        _endDateError = null;
      }
      _showBanner = _titleError != null ||
          _categoryError != null ||
          _startDateError != null ||
          _endDateError != null;
    });

    if (_showBanner) return;

    final DateTime startDate = _startDate!;
    final DateTime endDate = _endDate!;
    final TimeOfDay startTime = _startTime ?? const TimeOfDay(hour: 9, minute: 0);
    final TimeOfDay endTime = _endTime ?? const TimeOfDay(hour: 10, minute: 0);

    final Task result = (widget.initial ??
            Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: '',
              category: _category!,
              start: startDate,
              end: endDate,
            ))
        .copyWith(
      title: _title.text.trim(),
      category: _category,
      start: DateTime(startDate.year, startDate.month, startDate.day,
          startTime.hour, startTime.minute),
      end: DateTime(endDate.year, endDate.month, endDate.day, endTime.hour,
          endTime.minute),
      description: _description.text.trim(),
      emailReminder: _emailReminder,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final bool editing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(editing ? 'Edit Task' : 'Create Task'),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.md,
        ),
        child: PrimaryButton(
          label: editing ? 'Save changes' : 'Create Task',
          onPressed: _submit,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: <Widget>[
          if (_showBanner) ...<Widget>[
            const ErrorBanner(
              message: 'Please fix the errors below before submitting.',
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          AppTextField(
            label: 'Title',
            isRequired: true,
            hint: 'Enter task title',
            controller: _title,
            errorText: _titleError,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_titleError != null) setState(() => _titleError = null);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CategoryDropdown(
            label: 'Category',
            isRequired: true,
            value: _category,
            errorText: _categoryError,
            onChanged: (TaskCategory v) =>
                setState(() {
              _category = v;
              _categoryError = null;
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: DateField(
                  label: 'Start date',
                  isRequired: true,
                  value: _startDate,
                  errorText: _startDateError,
                  onTap: () => _pickDate(isStart: true),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DateField(
                  label: 'End date',
                  isRequired: true,
                  value: _endDate,
                  errorText: _endDateError,
                  onTap: () => _pickDate(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: TimeField(
                  label: 'Start time',
                  value: _startTime,
                  onTap: () => _pickTime(isStart: true),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TimeField(
                  label: 'End time',
                  value: _endTime,
                  onTap: () => _pickTime(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Description',
            hint: 'Add description (optional)',
            controller: _description,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: c.field,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: c.border),
            ),
            child: AppSwitch(
              title: 'Email reminder',
              subtitle: 'Get a reminder by email before this task',
              value: _emailReminder,
              onChanged: (bool v) => setState(() => _emailReminder = v),
            ),
          ),
        ],
      ),
    );
  }
}
