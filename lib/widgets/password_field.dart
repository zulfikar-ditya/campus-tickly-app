import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// Password input with an obscure/reveal eye toggle. Wraps [AppTextField].
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.label,
    this.isRequired = false,
    this.hint,
    this.controller,
    this.errorText,
    this.validator,
    this.textInputAction,
  });

  final String? label;
  final bool isRequired;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      isRequired: widget.isRequired,
      hint: widget.hint,
      controller: widget.controller,
      obscureText: _obscured,
      prefixIcon: Icons.lock_outline,
      errorText: widget.errorText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      suffixIcon: IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}
