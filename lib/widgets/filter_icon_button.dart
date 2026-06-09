import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Primary-colored square button beside the search field that opens the
/// Filters sheet.
class FilterIconButton extends StatelessWidget {
  const FilterIconButton({super.key, this.onTap, this.size = 56});

  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Material(
      color: c.primary,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(Icons.tune_rounded, color: c.onPrimary),
        ),
      ),
    );
  }
}
