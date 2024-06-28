import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class CenterContainerLayout extends StatelessWidget {
  const CenterContainerLayout({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 32.0,
    ),
    this.maxWidth = 440.0,
    required this.body,
  });

  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: padding,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32.0,
                ),
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldSecondary,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: AppColors.cardShadow,
                ),
                child: body,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
