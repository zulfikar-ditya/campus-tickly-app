import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Circular task checkbox: filled primary with a white check when [value] is
/// true, hollow outline when false.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 26,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? c.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? c.primary : c.border,
            width: 2,
          ),
        ),
        child: value
            ? Icon(Icons.check_rounded, size: size * 0.62, color: c.onPrimary)
            : null,
      ),
    );
  }
}
