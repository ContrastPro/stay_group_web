import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../resources/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: SpinKitSquareCircle(
          size: 50.0,
          color: AppColors.primary.withOpacity(0.6),
        ),
      ),
    );
  }
}
