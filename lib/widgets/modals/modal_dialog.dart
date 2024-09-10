import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class ModalDialog {
  const ModalDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    bool rootNavigation = false,
    bool barrierDismissible = true,
    Color? barrierColor,
    required Widget Function(BuildContext) builder,
  }) async {
    return await showDialog<T>(
      context: context,
      useRootNavigator: rootNavigation,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? AppColors.primary.withOpacity(0.35),
      builder: builder,
    );
  }
}
