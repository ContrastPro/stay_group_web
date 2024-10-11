import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';
import '../../utils/translate_locale.dart';

const TranslateLocale _locale = TranslateLocale('system');

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitFoldingCube(
              size: 50.0,
              color: AppColors.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 26.0),
            Material(
              color: AppColors.transparent,
              child: Text(
                _locale.tr('loading'),
                style: AppTextStyles.subtitleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
