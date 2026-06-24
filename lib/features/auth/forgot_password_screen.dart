import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../routing/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_toast.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final AuthController auth = context.read<AuthController>();
    final NavigatorState navigator = Navigator.of(context);
    final bool ok = await auth.forgotPassword(_email.text.trim());
    if (!mounted) return;
    if (ok) {
      AppToast.success(
        context,
        'If that email exists, a reset link has been sent.',
      );
      // The reset screen is opened from the emailed link (carrying a token);
      // we surface it here too so the flow matches the design.
      navigator.pushNamed(AppRoutes.resetPassword);
    } else {
      AppToast.error(context, auth.error ?? 'Could not send reset link.');
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
              PrimaryButton(
                label: 'Send reset link',
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
