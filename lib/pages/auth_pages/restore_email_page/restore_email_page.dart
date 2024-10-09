import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/container_layout.dart';

class RestoreEmailPage extends StatelessWidget {
  const RestoreEmailPage({
    super.key,
    required this.email,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/restore_email';

  final String? email;
  final void Function() navigateToLogInPage;

  @override
  Widget build(BuildContext context) {
    return ContainerLayout(
      body: Column(
        children: [
          AutoSizeText(
            'Check your email',
            style: AppTextStyles.head5SemiBold,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'We have sent password reset link to\n${email ?? 'placeholder'}',
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40.0),
          CustomButton(
            text: 'Back to login',
            onTap: navigateToLogInPage,
          ),
        ],
      ),
    );
  }
}
