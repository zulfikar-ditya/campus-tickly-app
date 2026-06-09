import 'package:flutter/material.dart';

import 'features/auth/create_account_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/tasks/home_screen.dart';
import 'routing/app_routes.dart';
import 'theme/app_theme.dart';

/// Root of the Tickly app. Wires light/dark themes and named routes.
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
      // Tap anywhere outside a text field to dismiss focus / keyboard.
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final FocusManager manager = FocusManager.instance;
            if (manager.primaryFocus?.hasPrimaryFocus ?? false) {
              manager.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
      initialRoute: AppRoutes.signIn,
      routes: <String, WidgetBuilder>{
        AppRoutes.signIn: (_) => const SignInScreen(),
        AppRoutes.createAccount: (_) => const CreateAccountScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },
    );
  }
}
