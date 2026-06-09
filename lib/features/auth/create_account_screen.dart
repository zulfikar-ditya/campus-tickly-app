import 'package:flutter/material.dart';

import '../../routing/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_footer.dart';
import '../../widgets/password_field.dart';
import '../../widgets/primary_button.dart';
import 'auth_scaffold.dart';

/// "Create account" — register a new user.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
      title: 'Create account',
      subtitle: 'Start organizing your day in minutes.',
      footer: AuthFooter(
        prompt: 'Already have an account?',
        actionLabel: 'Sign in',
        onTap: () => Navigator.of(context).maybePop(),
      ),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppTextField(
                label: 'Full name',
                hint: 'Your name',
                controller: _name,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.name],
                validator: (String? v) =>
                    Validators.requiredField(v, field: 'Full name'),
              ),
              const SizedBox(height: AppSpacing.md),
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
                hint: 'Create a password',
                controller: _password,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                label: 'Confirm password',
                hint: 'Re-enter password',
                controller: _confirm,
                textInputAction: TextInputAction.done,
                validator: Validators.matches(() => _password.text),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Sign Up', onPressed: _submit),
            ],
          ),
        ),
      ],
    );
  }
}
