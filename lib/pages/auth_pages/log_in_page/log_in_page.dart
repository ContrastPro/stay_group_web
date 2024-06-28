import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/center_container_layout.dart';
import '../../../widgets/text_fields/border_text_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.navigateToRestorePasswordPage,
    required this.navigateToDashboardPage,
    required this.navigateToSignUpPage,
  });

  static const routePath = '/auth_pages/log_in';

  final void Function() navigateToRestorePasswordPage;
  final void Function() navigateToDashboardPage;
  final void Function() navigateToSignUpPage;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isObscurePassword = true;

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return CenterContainerLayout(
      body: Column(
        children: [
          Text(
            'Welcome back',
            style: AppTextStyles.head5SemiBold,
          ),
          const SizedBox(height: 8.0),
          Text(
            "Dive back into your world with a simple sign-in. Your next adventure awaits - let's get started!",
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28.0),
          BorderTextField(
            labelText: 'Email',
            hintText: 'Placeholder',
            prefixIcon: AppIcons.mail,
            focusListener: (_) {
              //
            },
          ),
          const SizedBox(height: 16.0),
          BorderTextField(
            labelText: 'Password',
            hintText: 'Password',
            isObscureText: _isObscurePassword,
            prefixIcon: AppIcons.lock,
            suffixIcon: _isObscurePassword
                ? AppIcons.visibilityOff
                : AppIcons.visibilityOn,
            onSuffixTap: _switchObscurePassword,
            focusListener: (_) {
              //
            },
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: widget.navigateToRestorePasswordPage,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.paragraphSMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          CustomButton(
            text: 'Log in',
            onTap: widget.navigateToDashboardPage,
          ),
          const SizedBox(height: 40.0),
          GestureDetector(
            onTap: widget.navigateToSignUpPage,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: AppTextStyles.paragraphSMedium.copyWith(
                    color: AppColors.iconPrimary,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Register now!',
                  style: AppTextStyles.paragraphSMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
