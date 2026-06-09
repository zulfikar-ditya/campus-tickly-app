import 'package:flutter/material.dart';

/// Builds the app's [TextTheme] for a given primary text [color].
///
/// Uses the platform default font (Roboto) — no custom font is bundled. Sizes
/// and weights are tuned to the design: bold screen titles, semibold section
/// headers / buttons, regular body, muted captions.
abstract final class AppTypography {
  static TextTheme textTheme(Color color) {
    return TextTheme(
      // Screen titles e.g. "Welcome back", "Create account".
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      // Greeting name, large headings.
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      // AppBar titles ("Create Task", "Edit Task").
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      // Section headers ("Today", "Filters"), card titles.
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      // Task titles.
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: TextStyle(fontSize: 15, color: color),
      bodyMedium: TextStyle(fontSize: 14, color: color),
      // Captions / helper text / times.
      bodySmall: TextStyle(fontSize: 12, color: color),
      // Field labels and button text.
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
