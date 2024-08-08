import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../buttons/custom_button.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.isEmpty,
    required this.animation,
    required this.title,
    required this.description,
    required this.buttonWidth,
    required this.buttonText,
    required this.content,
    required this.onTap,
  });

  final bool isEmpty;
  final String animation;
  final String title;
  final String description;
  final double buttonWidth;
  final String buttonText;
  final Widget content;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 380.0,
            child: Lottie.asset(
              animation,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.subtitleBold,
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: AppTextStyles.paragraphSRegular.copyWith(
              color: AppColors.iconPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: buttonWidth,
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
