import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'app_progress_bar.dart';

/// "Today's progress" card on the home screen: completed/total + percentage on
/// a red gradient, with a white progress bar. Handles the empty (0 of 0) case.
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double value = total == 0 ? 0 : completed / total;
    final String percentLabel = '${(value * 100).round()}%';
    final Color onCard = Colors.white;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: <Color>[AppPalette.rose500, AppPalette.rose600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Today's progress",
                    style: context.text.bodySmall?.copyWith(
                      color: onCard.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed of $total completed',
                    style: context.text.titleMedium?.copyWith(
                      color: onCard,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                percentLabel,
                style: context.text.headlineSmall?.copyWith(
                  color: onCard,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            value: value,
            fillColor: onCard,
            trackColor: onCard.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
