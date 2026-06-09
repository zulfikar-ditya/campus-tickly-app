import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'field_label.dart';

/// A read-only, tappable field that looks like a text input but opens a picker
/// on tap (date, time, category). Shows a placeholder until a [value] is set,
/// an optional leading icon, an optional [trailing] widget (e.g. chevron), and
/// inline error styling. Reused by the date/time fields and category dropdown.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    this.label,
    this.isRequired = false,
    required this.placeholder,
    this.value,
    this.leadingIcon,
    this.leadingIconColor,
    this.trailing,
    this.onTap,
    this.errorText,
  });

  final String? label;
  final bool isRequired;
  final String placeholder;
  final String? value;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final bool hasValue = value != null && value!.isNotEmpty;
    final bool hasError = errorText != null;

    final Widget box = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: c.field,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: hasError ? c.error : c.border,
            width: hasError ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            if (leadingIcon != null) ...<Widget>[
              Icon(
                leadingIcon,
                size: 18,
                color: leadingIconColor ?? c.textMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                hasValue ? value! : placeholder,
                style: context.text.bodyMedium?.copyWith(
                  color: hasValue ? c.textPrimary : c.textMuted,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null) FieldLabel(label!, isRequired: isRequired),
        box,
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText!,
              style: context.text.bodySmall?.copyWith(color: c.error),
            ),
          ),
      ],
    );
  }
}
