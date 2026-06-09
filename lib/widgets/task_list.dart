import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_spacing.dart';
import 'task_card.dart';

/// Vertical list of [TaskCard]s. Action callbacks receive the affected [Task];
/// edit/delete icons only render when the corresponding callback is provided.
class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  final List<Task> tasks;
  final void Function(Task task, bool value)? onToggle;
  final void Function(Task task)? onEdit;
  final void Function(Task task)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < tasks.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          TaskCard(
            task: tasks[i],
            onToggle: onToggle == null
                ? null
                : (bool v) => onToggle!(tasks[i], v),
            onEdit: onEdit == null ? null : () => onEdit!(tasks[i]),
            onDelete: onDelete == null ? null : () => onDelete!(tasks[i]),
          ),
        ],
      ],
    );
  }
}
