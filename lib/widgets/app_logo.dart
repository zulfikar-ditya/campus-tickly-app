import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Tickly brand mark: a rounded primary square with a check, optionally
/// followed by the "Tickly" wordmark.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32, this.showWordmark = true});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final Widget mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.check_rounded, color: c.onPrimary, size: size * 0.66),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        const SizedBox(width: AppSpacing.sm),
        Text('Tickly', style: context.text.titleLarge),
      ],
    );
  }
}
