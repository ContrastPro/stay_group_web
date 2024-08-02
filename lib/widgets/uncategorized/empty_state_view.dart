import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/app_animations.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../buttons/custom_button.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.isEmpty,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.content,
    required this.onTap,
  });

  final bool isEmpty;
  final String title;
  final String description;
  final String buttonText;
  final Widget content;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            width: 480.0,
            AppAnimations.empty,
          ),
          Text(
            title,
            style: AppTextStyles.head5SemiBold,
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28.0),
          SizedBox(
            width: 140.0,
            child: CustomButton(
              prefixIcon: AppIcons.add,
              text: buttonText,
              backgroundColor: AppColors.info,
              onTap: onTap,
            ),
          ),
        ],
      );
    }

    return content;
  }
}
