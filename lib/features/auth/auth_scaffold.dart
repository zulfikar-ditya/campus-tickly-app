import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_logo.dart';

/// Shared layout for the auth screens: an optional back button and/or logo at
/// the top, a title + subtitle, a scrollable form body, and a footer pinned to
/// the bottom.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showLogo = false,
    this.showBack = false,
    this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showLogo;
  final bool showBack;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (showBack)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: showBack ? AppSpacing.sm : AppSpacing.xxl,
                      ),
                      if (showLogo) ...<Widget>[
                        const AppLogo(),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                      Text(title, style: context.text.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: context.text.bodyMedium?.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ...children,
                    ],
                  ),
                ),
              ),
              if (footer != null) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: footer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
