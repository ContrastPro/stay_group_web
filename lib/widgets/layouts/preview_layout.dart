import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({
    super.key,
    required this.content,
    required this.preview,
  });

  final Widget content;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.scaffoldSecondary,
            border: Border.all(
              color: AppColors.border,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 512.0,
                child: content,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 32.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.iconPrimary.withOpacity(0.04),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  child: preview,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
