import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/app_colors.dart';
import '../uncategorized/splash_box.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.addBorder = true,
    this.iconColor = AppColors.scaffoldSecondary,
    this.backgroundColor = AppColors.primary,
    this.splashColor = AppColors.secondary,
    required this.onTap,
  });

  final String icon;
  final bool addBorder;
  final Color iconColor;
  final Color backgroundColor;
  final Color splashColor;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SplashBox(
      onTap: onTap,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          border: addBorder
              ? Border.all(
                  color: AppColors.border,
                )
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          width: 22.0,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
