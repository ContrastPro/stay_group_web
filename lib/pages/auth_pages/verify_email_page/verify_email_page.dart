import 'package:flutter/material.dart';

import '../../../resources/app_text_styles.dart';
import '../../../widgets/layouts/center_container_layout.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    super.key,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/verify_email';

  final void Function() navigateToLogInPage;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return CenterContainerLayout(
      body: Column(
        children: [
          Text(
            'Check your email',
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
