import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../resources/app_text_styles.dart';
import '../utils/constants.dart';

enum InAppNotificationType { info, warning, error }

class InAppNotificationService {
  const InAppNotificationService._();

  static void show({
    String title = 'Here is a test message!',
    InAppNotificationType type = InAppNotificationType.info,
  }) {
    BotToast.showCustomNotification(
      onlyOne: true,
      duration: const Duration(
        milliseconds: 10000,
      ),
      animationDuration: const Duration(
        milliseconds: 450,
      ),
      toastBuilder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 320.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.scaffoldSecondary,
                boxShadow: AppColors.mediumShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: kCircleRadius,
                        color: _notificationIconColor(type),
                      ),
                      child: Icon(
                        _notificationIcon(type),
                        size: 16.0,
                        color: AppColors.scaffoldSecondary,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Text(
                        title,
                        style: AppTextStyles.paragraphSRegular.copyWith(
                          color: AppColors.iconPrimary,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static IconData _notificationIcon(InAppNotificationType type) {
    if (type == InAppNotificationType.warning) {
      return Icons.warning_rounded;
    }

    if (type == InAppNotificationType.error) {
      return Icons.close_rounded;
    }

    return Icons.done_rounded;
  }

  static Color _notificationIconColor(InAppNotificationType type) {
    if (type == InAppNotificationType.warning) return AppColors.warning;
    if (type == InAppNotificationType.error) return AppColors.error;
    return AppColors.success;
  }
}
