import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A labeled toggle row (used for the "Email reminder" setting). The track/
/// thumb colors come from [SwitchTheme]; this composes it with a title and
/// optional subtitle.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    final Widget toggle = Switch(value: value, onChanged: onChanged);

    if (title == null) return toggle;

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title!, style: context.text.labelLarge),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.text.bodySmall?.copyWith(
                    color: c.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        toggle,
      ],
    );
  }
}
