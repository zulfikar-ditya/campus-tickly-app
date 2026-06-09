import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Inline tappable primary-colored text ("Sign up", "Forgot password?",
/// "Back to sign in").
class TextLink extends StatelessWidget {
  const TextLink(this.label, {super.key, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: context.text.labelLarge?.copyWith(color: context.colors.primary),
      ),
    );
  }
}
