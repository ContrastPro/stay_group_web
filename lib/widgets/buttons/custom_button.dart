import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';
import '../uncategorized/splash_box.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.prefixIcon,
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.scaffoldSecondary,
    required this.onTap,
  });

  final String? prefixIcon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SplashBox(
      onTap: onTap,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: double.infinity,
        height: 44.0,
        decoration: BoxDecoration(
          boxShadow: AppColors.regularShadow,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              SvgPicture.asset(
                prefixIcon!,
                width: 22.0,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4.0),
            ],
            Text(
              text,
              style: AppTextStyles.paragraphMMedium.copyWith(
                color: textColor,
              ),
            ),
            if (prefixIcon != null) ...[
              const SizedBox(width: 8.0),
            ],
          ],
        ),
      ),
    );
  }
}
