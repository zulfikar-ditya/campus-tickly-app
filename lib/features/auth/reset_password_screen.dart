import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // The reset token arrives via the emailed link (passed as a route argument).
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String token = args is String ? args : '';

    final AuthController auth = context.read<AuthController>();
    final NavigatorState navigator = Navigator.of(context);
    final bool ok = await auth.resetPassword(token, _password.text);
    if (!mounted) return;
    if (ok) {
      AppToast.success(context, 'Password updated. Please sign in.');
      navigator.popUntil((Route<dynamic> r) => r.isFirst);
    } else {
      AppToast.error(context, auth.error ?? 'Could not reset password.');
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
              PrimaryButton(
                label: 'Save new password',
                isLoading: context.watch<AuthController>().busy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
