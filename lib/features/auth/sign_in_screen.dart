import 'package:flutter/material.dart';

import '../../routing/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_footer.dart';
import '../../widgets/password_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_link.dart';
import 'auth_scaffold.dart';

/// "Welcome back" — sign in.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showLogo: true,
      title: 'Welcome back',
      subtitle: 'Sign in to continue managing your tasks.',
      footer: AuthFooter(
        prompt: "Don't have an account?",
        actionLabel: 'Sign up',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.createAccount),
      ),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppTextField(
                label: 'Email',
                hint: 'you@email.com',
                controller: _email,
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                label: 'Password',
                hint: 'Enter password',
                controller: _password,
                textInputAction: TextInputAction.done,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextLink(
                  'Forgot password?',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Sign In', onPressed: _submit),
            ],
          ),
        ),
      ],
    );
  }
}
