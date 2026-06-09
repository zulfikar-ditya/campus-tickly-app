import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';

/// A single day cell in the home week strip: weekday label over the day
/// number. Filled primary when [selected].
class DateCell extends StatelessWidget {
  const DateCell({
    super.key,
    required this.date,
    this.selected = false,
    this.onTap,
    this.width = 52,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final Color foreground = selected ? c.onPrimary : c.textPrimary;
    final Color weekdayColor = selected
        ? c.onPrimary.withValues(alpha: 0.9)
        : c.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: selected ? c.primary : c.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              weekdayLabel(date),
              style: context.text.bodySmall?.copyWith(color: weekdayColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: context.text.titleMedium?.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
