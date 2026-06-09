import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'text_link.dart';

/// Centered prompt + link at the bottom of the auth screens, e.g.
/// "Don't have an account? Sign up".
class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.prompt,
    required this.actionLabel,
    this.onTap,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          prompt,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        TextLink(actionLabel, onTap: onTap),
      ],
    );
  }
}
