import 'package:flutter/material.dart';

/// Task categories seen in the design, each with its own accent color used by
/// the category tag/chip.
///
/// NOTE: tag colors are a first-pass mapping (distinct Tailwind hues); verify
/// against `docs/design.jpg` when building the `CategoryTag` widget and adjust.
enum TaskCategory {
  work('Work', Color(0xFF3B82F6)), // blue-500
  meeting('Meeting', Color(0xFF8B5CF6)), // violet-500
  backend('Backend', Color(0xFF10B981)), // emerald-500
  personal('Personal', Color(0xFFF59E0B)); // amber-500

  const TaskCategory(this.label, this.color);

  /// Human-readable label shown in the UI.
  final String label;

  /// Accent color for this category's tag.
  final Color color;
}
