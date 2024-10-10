import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/translate_locale.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/container_layout.dart';

const TranslateLocale _locale = TranslateLocale('auth.verify_email');

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({
    super.key,
    required this.email,
    required this.navigateToLogInPage,
  });

  static const routePath = '/auth_pages/verify_email';

  final String? email;
  final void Function() navigateToLogInPage;

  @override
  Widget build(BuildContext context) {
    return ContainerLayout(
      body: Column(
        children: [
          AutoSizeText(
            _locale.tr('check_email'),
            style: AppTextStyles.head5SemiBold,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            _locale.tr('we_sent_email', args: [
              email ?? 'placeholder',
            ]),
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40.0),
          CustomButton(
            text: _locale.tr('back_to_login'),
            onTap: navigateToLogInPage,
          ),
        ],
      ),
    );
  }
}
