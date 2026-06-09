import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Full-width filled primary action button (styling from [FilledButtonTheme]).
/// Shows a spinner and disables interaction while [isLoading].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.onPrimary,
                ),
              ),
            )
          : Text(label),
    );
  }
}
