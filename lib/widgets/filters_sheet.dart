import 'package:flutter/material.dart';

import '../models/filter_selection.dart';
import '../models/task_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_calendar.dart';
import 'primary_button.dart';
import 'selectable_chip.dart';
import 'text_link.dart';

/// Shows the Filters bottom sheet, returning the chosen [FilterSelection] when
/// the user taps "Show results", or null if dismissed.
Future<FilterSelection?> showFiltersSheet(
  BuildContext context,
  FilterSelection initial,
) {
  return showModalBottomSheet<FilterSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _FiltersSheet(initial: initial),
  );
}

class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});

  final FilterSelection initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late FilterSelection _selection = widget.initial;
  late DateTime _calendarMonth = widget.initial.customDate ?? DateTime.now();

  void _reset() => setState(() {
    _selection = const FilterSelection();
    _calendarMonth = DateTime.now();
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screen,
          right: AppSpacing.screen,
          top: AppSpacing.md,
          bottom: AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Filters', style: context.text.titleLarge),
                  TextLink('Reset', onTap: _reset),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _SectionLabel('Date'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: <Widget>[
                  for (final DateRangeFilter range in DateRangeFilter.values)
                    SelectableChip(
                      label: range.label,
                      selected: _selection.dateRange == range,
                      onTap: () => setState(() {
                        _selection = _selection.copyWith(
                          dateRange: range,
                          clearCustomDate: range != DateRangeFilter.custom,
                        );
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCalendar(
                month: _calendarMonth,
                selectedDate: _selection.customDate,
                onMonthChanged: (DateTime m) =>
                    setState(() => _calendarMonth = m),
                onDaySelected: (DateTime day) => setState(() {
                  _selection = _selection.copyWith(
                    customDate: day,
                    dateRange: DateRangeFilter.custom,
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SectionLabel('Type'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: <Widget>[
                  SelectableChip(
                    label: 'All',
                    selected: _selection.category == null,
                    onTap: () => setState(() {
                      _selection = _selection.copyWith(clearCategory: true);
                    }),
                  ),
                  for (final TaskCategory category in TaskCategory.values)
                    SelectableChip(
                      label: category.label,
                      selected: _selection.category == category,
                      onTap: () => setState(() {
                        _selection = _selection.copyWith(category: category);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Show results',
                onPressed: () => Navigator.of(context).pop(_selection),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.text.labelLarge);
  }
}
