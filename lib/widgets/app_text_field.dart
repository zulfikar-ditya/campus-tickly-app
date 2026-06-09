import 'package:flutter/material.dart';

import 'field_label.dart';

/// Labeled text input built on [TextFormField]. Pairs a [FieldLabel] (when
/// [label] is set) with a themed input. Supports a leading icon, trailing
/// widget (e.g. password eye toggle), multiline, and inline error text.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.isRequired = false,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.maxLines = 1,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.autofillHints,
  });

  final String? label;
  final bool isRequired;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final Widget field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
        errorText: errorText,
        alignLabelWithHint: maxLines > 1,
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FieldLabel(label!, isRequired: isRequired),
        field,
      ],
    );
  }
}
