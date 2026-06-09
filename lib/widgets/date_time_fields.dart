import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'picker_field.dart';

/// Tappable date field (leading primary calendar icon + formatted date).
/// Opening the actual date picker is the caller's responsibility via [onTap].
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    this.label,
    this.isRequired = false,
    required this.value,
    this.onTap,
    this.errorText,
  });

  final String? label;
  final bool isRequired;
  final DateTime? value;
  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      label: label,
      isRequired: isRequired,
      placeholder: 'Select date',
      value: value == null ? null : formatDate(value!),
      leadingIcon: Icons.calendar_today_outlined,
      leadingIconColor: context.colors.primary,
      onTap: onTap,
      errorText: errorText,
    );
  }
}

/// Tappable time field (leading clock icon + formatted time).
class TimeField extends StatelessWidget {
  const TimeField({
    super.key,
    this.label,
    this.isRequired = false,
    required this.value,
    this.onTap,
    this.errorText,
  });

  final String? label;
  final bool isRequired;
  final TimeOfDay? value;
  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      label: label,
      isRequired: isRequired,
      placeholder: 'Select time',
      value: value?.format(context),
      leadingIcon: Icons.access_time_rounded,
      onTap: onTap,
      errorText: errorText,
    );
  }
}
