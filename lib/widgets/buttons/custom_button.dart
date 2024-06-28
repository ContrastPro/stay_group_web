import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';
import '../uncategorized/splash_box.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SplashBox(
      onTap: onTap,
      backgroundColor: AppColors.primary,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: double.infinity,
        height: 44.0,
        decoration: BoxDecoration(
          boxShadow: AppColors.lightShadow,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.paragraphMMedium.copyWith(
            color: AppColors.scaffoldSecondary,
          ),
        ),
      ),
    );
  }
}
