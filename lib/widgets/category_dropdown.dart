import 'package:flutter/material.dart';

import '../models/task_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'picker_field.dart';

/// Category selector styled like an input. Tapping opens a bottom sheet listing
/// the [TaskCategory] options.
class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    this.label,
    this.isRequired = false,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final String? label;
  final bool isRequired;
  final TaskCategory? value;
  final ValueChanged<TaskCategory> onChanged;
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final TaskCategory? selected = await showModalBottomSheet<TaskCategory>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext sheetContext) {
        final AppColors c = sheetContext.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final TaskCategory category in TaskCategory.values)
                ListTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  title: Text(category.label, style: sheetContext.text.bodyLarge),
                  trailing: category == value
                      ? Icon(Icons.check_rounded, color: c.primary)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(category),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return PickerField(
      label: label,
      isRequired: isRequired,
      placeholder: 'Select category',
      value: value?.label,
      errorText: errorText,
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.textMuted,
      ),
      onTap: () => _pick(context),
    );
  }
}
