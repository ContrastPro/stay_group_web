import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class CenterContainerLayout extends StatelessWidget {
  const CenterContainerLayout({
    super.key,
    required this.body,
  });

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 32.0,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32.0,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 440.0,
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
