import 'package:flutter/material.dart';

import '../../routing/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_footer.dart';
import '../../widgets/primary_button.dart';
import 'auth_scaffold.dart';

/// "Forgot password?" — request a reset link by email.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(AppRoutes.resetPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      title: 'Forgot password?',
      subtitle:
          "Enter the email linked to your account and we'll send a "
          'reset link.',
      footer: AuthFooter(
        prompt: 'Remember it?',
        actionLabel: 'Back to sign in',
        onTap: () => Navigator.of(context).maybePop(),
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
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Send reset link', onPressed: _submit),
            ],
          ),
        ),
      ],
    );
  }
}
