import 'package:flutter/material.dart';

/// Raw color palette sampled from `docs/design.jpg`.
///
/// The design is built on Tailwind's **rose** scale (the red/pink accent) and
/// **slate** scale (neutrals / dark surfaces). These are the primitive values;
/// screens should consume the semantic [AppColors] tokens, not these directly.
abstract final class AppPalette {
  // Accent — rose
  static const Color rose50 = Color(0xFFFFF1F2);
  static const Color rose100 = Color(0xFFFFE4E6);
  static const Color rose200 = Color(0xFFFECDD3);
  static const Color rose400 = Color(0xFFFB7185);
  static const Color rose500 = Color(0xFFF43F5E); // primary accent
  static const Color rose600 = Color(0xFFE11D48); // pressed

  // Neutrals — slate
  static const Color white = Color(0xFFFFFFFF);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B); // dark surface / card
  static const Color slate900 = Color(0xFF0F172A); // dark background
  static const Color slate950 = Color(0xFF020617);

  // Feedback
  static const Color emerald500 = Color(0xFF10B981); // success toast
  static const Color red500 = Color(0xFFEF4444); // error
}
