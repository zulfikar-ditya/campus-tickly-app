import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Circular avatar showing the first initial of [name] over a tinted
/// background (used in the home header).
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.name, this.size = 44});

  final String name;
  final double size;

  String get _initial {
    final String trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.avatarBackground,
        shape: BoxShape.circle,
      ),
      child: Text(
        _initial,
        style: context.text.titleMedium?.copyWith(color: c.primary),
      ),
    );
  }
}
