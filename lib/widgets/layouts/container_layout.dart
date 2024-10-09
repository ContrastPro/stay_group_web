import 'dart:developer';

import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class ContainerLayout extends StatelessWidget {
  const ContainerLayout({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final Size size = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          log('${size.width} x ${size.height}', name: 'Screen size');

          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: size.height,
              ),
              child: Center(
                child: Container(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
