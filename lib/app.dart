import 'package:flutter/material.dart';

import 'features/auth/create_account_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'foundation_preview.dart';
import 'routing/app_routes.dart';
import 'theme/app_theme.dart';

/// Root of the Tickly app. Wires light/dark themes and named routes.
///
/// NOTE: [AppRoutes.home] temporarily maps to the component gallery
/// (`FoundationPreview`); it will be replaced by the real Home screen.
class TicklyApp extends StatelessWidget {
  const TicklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tickly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.signIn,
      routes: <String, WidgetBuilder>{
        AppRoutes.signIn: (_) => const SignInScreen(),
        AppRoutes.createAccount: (_) => const CreateAccountScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
        AppRoutes.home: (_) => const FoundationPreview(),
      },
    );
  }
}
