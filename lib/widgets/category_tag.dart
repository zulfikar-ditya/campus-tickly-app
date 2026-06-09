import 'package:flutter/material.dart';

import '../models/task_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Small pill marking a task's category: a colored dot + label on a faint
/// neutral background (as seen on task rows in the design).
class CategoryTag extends StatelessWidget {
  const CategoryTag(this.category, {super.key});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: c.field,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            category.label,
            style: context.text.bodySmall?.copyWith(
              color: c.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
