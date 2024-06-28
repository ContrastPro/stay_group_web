import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class SplashBox extends StatelessWidget {
  const SplashBox({
    super.key,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = AppColors.transparent,
    this.splashColor = AppColors.secondary,
    this.borderRadius = BorderRadius.zero,
    required this.child,
    this.onTap,
  });

  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color splashColor;
  final BorderRadius borderRadius;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          splashColor: splashColor,
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
