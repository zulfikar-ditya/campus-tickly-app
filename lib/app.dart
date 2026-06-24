import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'features/auth/create_account_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/tasks/home_screen.dart';
import 'routing/app_routes.dart';
import 'theme/app_theme.dart';

/// Root of the Tickly app. Wires light/dark themes and the auth gate.
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
      home: const _AuthGate(),
      // Auth sub-screens are pushed by name on top of the gate's Navigator.
      routes: <String, WidgetBuilder>{
        AppRoutes.createAccount: (_) => const CreateAccountScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
      },
    );
  }
}

/// Chooses the first screen based on the restored auth session. When the user
/// signs in or out, [AuthController] flips the status and this rebuilds.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final AuthStatus status = context.select<AuthController, AuthStatus>(
      (AuthController c) => c.status,
    );

    switch (status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
        return const SignInScreen();
    }
  }
}
