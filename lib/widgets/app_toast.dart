import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Floating success/error toast (snackbar) matching the design's
/// "Task created successfully!" / "Failed to save. Please try again." states.
abstract final class AppToast {
  static void success(BuildContext context, String message) =>
      _show(context, message, isError: false);

  static void error(BuildContext context, String message) =>
      _show(context, message, isError: true);

  static void _show(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    final AppColors c = context.colors;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? c.error : c.success,
        elevation: 0,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        content: Row(
          children: <Widget>[
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: c.onSuccess,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: c.onSuccess,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
