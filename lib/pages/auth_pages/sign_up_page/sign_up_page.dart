import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/center_container_layout.dart';
import '../../../widgets/text_fields/border_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.navigateToVerifyEmailPage,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/sign_up';

  final void Function(String) navigateToVerifyEmailPage;
  final void Function() navigateToLogInPage;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isObscurePassword = true;
  bool _isObscurePasswordConfirm = true;

  void _switchObscurePassword() {
    setState(() => _isObscurePassword = !_isObscurePassword);
  }

  void _switchObscurePasswordConfirm() {
    setState(() => _isObscurePasswordConfirm = !_isObscurePasswordConfirm);
  }

  @override
  Widget build(BuildContext context) {
    return CenterContainerLayout(
      body: Column(
        children: [
          Text(
            'Join us today',
            style: AppTextStyles.head5SemiBold,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Sign up today and unlock a world of possibilities. Your adventure begins here.',
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28.0),
          BorderTextField(
            labelText: 'Username',
            hintText: 'Username',
            prefixIcon: AppIcons.user,
            focusListener: (_) {
              //
            },
          ),
          const SizedBox(height: 16.0),
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
          const SizedBox(height: 16.0),
          BorderTextField(
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            isObscureText: _isObscurePasswordConfirm,
            prefixIcon: AppIcons.lock,
            suffixIcon: _isObscurePasswordConfirm
                ? AppIcons.visibilityOff
                : AppIcons.visibilityOn,
            onSuffixTap: _switchObscurePasswordConfirm,
            focusListener: (_) {
              //
            },
          ),
          const SizedBox(height: 40.0),
          CustomButton(
            text: 'Sign up',
            onTap: widget.navigateToVerifyEmailPage,
          ),
          const SizedBox(height: 40.0),
          GestureDetector(
            onTap: widget.navigateToLogInPage,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: AppTextStyles.paragraphSMedium.copyWith(
                    color: AppColors.iconPrimary,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Log in',
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
