import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Label shown above a form field. Appends a primary-colored `*` when
/// [isRequired] (matches the "Title *" style in the Create Task error state).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.isRequired = false});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: context.text.labelLarge?.copyWith(color: c.textPrimary),
          children: isRequired
              ? <InlineSpan>[
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: c.primary),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
