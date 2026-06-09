import 'package:flutter/material.dart';

import '../models/task_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Small neutral pill marking a task's category, e.g. "Work" — a faint
/// background with muted label text, matching the task rows in the design.
class CategoryTag extends StatelessWidget {
  const CategoryTag(this.category, {super.key});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: c.field,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        category.label,
        style: context.text.bodySmall?.copyWith(
          color: c.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
