import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../loaders/custom_loader.dart';

class ActionLoader extends StatelessWidget {
  const ActionLoader({
    super.key,
    required this.isLoading,
    this.opacity = 0.85,
    required this.child,
  });

  final bool isLoading;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (isLoading) ...[
            Container(
              color: AppColors.scaffoldPrimary.withOpacity(opacity),
              child: const CustomLoader(),
            ),
          ],
        ],
      ),
    );
  }
}
