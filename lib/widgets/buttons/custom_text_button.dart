import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';
import '../uncategorized/splash_box.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.prefixIcon,
    required this.text,
    required this.onTap,
  });

  final String? prefixIcon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SplashBox(
      onTap: onTap,
      backgroundColor: AppColors.scaffoldSecondary,
      splashColor: AppColors.scaffoldPrimary,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 44.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              SvgPicture.asset(
                prefixIcon!,
                width: 22.0,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
            Text(
              text,
              style: AppTextStyles.paragraphMMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
