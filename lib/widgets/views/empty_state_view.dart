import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../../utils/constants.dart';
import '../buttons/custom_button.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.screenSize,
    required this.isEmpty,
    required this.animation,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.content,
    required this.onTap,
  });

  final Size screenSize;
  final bool isEmpty;
  final String animation;
  final String title;
  final String description;
  final String buttonText;
  final Widget content;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenSize.height - 120.0,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height:
                      screenSize.width >= kMobileScreenWidth ? 360.0 : 280.0,
                  child: OverflowBox(
                    minHeight: 180.0,
                    maxHeight:
                        screenSize.width >= kMobileScreenWidth ? 460.0 : 360.0,
                    child: Lottie.asset(
                      animation,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.subtitleBold,
                  textAlign: TextAlign.center,
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
                  width: 240.0,
                  child: CustomButton(
                    prefixIcon: AppIcons.add,
                    text: buttonText,
                    backgroundColor: AppColors.info,
                    onTap: onTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return content;
  }
}
