import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';
import 'app_checkbox.dart';
import 'category_tag.dart';

/// A single task row: completion checkbox, title (strikethrough + muted when
/// done), category tag + start time, and optional edit/delete actions.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  final Task task;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final bool done = task.isDone;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: <Widget>[
          AppCheckbox(value: done, onChanged: onToggle),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  style: context.text.titleSmall?.copyWith(
                    color: done ? c.textMuted : c.textPrimary,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    CategoryTag(task.category),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: c.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatClock(task.start),
                      style: context.text.bodySmall?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.edit_outlined, size: 18, color: c.textMuted),
              onPressed: onEdit,
            ),
          if (onDelete != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.delete_outline, size: 18, color: c.textMuted),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
