import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import 'custom_drawer.dart';

class FlexibleLayout extends StatelessWidget {
  const FlexibleLayout({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: CustomDrawer(),
            ),
            Expanded(
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
                child: Center(child: body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
