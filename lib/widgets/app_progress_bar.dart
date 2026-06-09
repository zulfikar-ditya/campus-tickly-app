import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Rounded determinate progress bar. Defaults to primary fill, but accepts
/// overrides so it can render on the colored progress card (white-on-red).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.fillColor,
    this.trackColor,
  });

  /// Progress in 0..1.
  final double value;
  final double height;
  final Color? fillColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: trackColor ?? c.border,
        valueColor: AlwaysStoppedAnimation<Color>(fillColor ?? c.primary),
      ),
    );
  }
}
