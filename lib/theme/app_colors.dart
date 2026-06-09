import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Semantic color tokens for Tickly, available in light and dark variants.
///
/// Registered as a [ThemeExtension] so widgets resolve the right value for the
/// active brightness via `context.colors`. Use these instead of [AppPalette]
/// primitives so light/dark mode "just works".
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.field,
    required this.border,
    required this.primary,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.onSuccess,
    required this.error,
    required this.avatarBackground,
  });

  /// Scaffold / page background.
  final Color background;

  /// Cards, sheets, elevated containers.
  final Color surface;

  /// Input field fill.
  final Color field;

  /// Hairline borders / dividers.
  final Color border;

  /// Accent used for primary actions, selection, progress.
  final Color primary;
  final Color onPrimary;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color success;
  final Color onSuccess;
  final Color error;

  final Color avatarBackground;

  static const AppColors light = AppColors(
    background: AppPalette.slate50,
    surface: AppPalette.white,
    field: AppPalette.slate100,
    border: AppPalette.slate200,
    primary: AppPalette.rose500,
    onPrimary: AppPalette.white,
    textPrimary: AppPalette.slate900,
    textSecondary: AppPalette.slate500,
    textMuted: AppPalette.slate400,
    success: AppPalette.emerald500,
    onSuccess: AppPalette.white,
    error: AppPalette.red500,
    avatarBackground: AppPalette.rose100,
  );

  static const AppColors dark = AppColors(
    background: AppPalette.slate900,
    surface: AppPalette.slate800,
    field: AppPalette.slate800,
    border: AppPalette.slate700,
    primary: AppPalette.rose500,
    onPrimary: AppPalette.white,
    textPrimary: AppPalette.white,
    textSecondary: AppPalette.slate400,
    textMuted: AppPalette.slate500,
    success: AppPalette.emerald500,
    onSuccess: AppPalette.white,
    error: AppPalette.red500,
    avatarBackground: AppPalette.slate700,
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? field,
    Color? border,
    Color? primary,
    Color? onPrimary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? success,
    Color? onSuccess,
    Color? error,
    Color? avatarBackground,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      field: field ?? this.field,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      error: error ?? this.error,
      avatarBackground: avatarBackground ?? this.avatarBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      field: Color.lerp(field, other.field, t)!,
      border: Color.lerp(border, other.border, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      error: Color.lerp(error, other.error, t)!,
      avatarBackground: Color.lerp(
        avatarBackground,
        other.avatarBackground,
        t,
      )!,
    );
  }
}

/// Convenience accessors so widgets can read `context.colors` / `context.text`.
extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
}
