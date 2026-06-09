import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Row with a section [title] on the left and an optional [trailing] string
/// (e.g. "5 tasks") on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: context.text.titleMedium),
        if (trailing != null)
          Text(
            trailing!,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
      ],
    );
  }
}
