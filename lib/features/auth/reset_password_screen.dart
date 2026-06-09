import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/auth_footer.dart';
import '../../widgets/password_field.dart';
import '../../widgets/primary_button.dart';
import 'auth_scaffold.dart';

/// "Reset password" — set a new password after following a reset link.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      AppToast.success(context, 'Password updated. Please sign in.');
      Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      title: 'Reset password',
      subtitle: 'Create a new password. Make it strong and easy to remember.',
      footer: AuthFooter(
        prompt: 'Remember it?',
        actionLabel: 'Back to sign in',
        onTap: () =>
            Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst),
      ),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PasswordField(
                label: 'New password',
                hint: 'Enter new password',
                controller: _password,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                label: 'Confirm password',
                hint: 'Re-enter new password',
                controller: _confirm,
                textInputAction: TextInputAction.done,
                validator: Validators.matches(() => _password.text),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Save new password', onPressed: _submit),
            ],
          ),
        ),
      ],
    );
  }
}
