import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../resources/app_text_styles.dart';

enum InAppNotificationType { info, success, caution, error }

class InAppNotificationService {
  const InAppNotificationService._();

  static void show({
    required String title,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: _notificationColor(type),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _notificationIcon(type),
                        color: AppColors.scaffoldPrimary,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        _notificationTitle(type),
                        style: AppTextStyles.subtitleMedium.copyWith(
                          color: AppColors.scaffoldSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    title,
                    style: AppTextStyles.paragraphMRegular.copyWith(
                      color: AppColors.scaffoldSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Color _notificationColor(InAppNotificationType type) {
    if (type == InAppNotificationType.success) return AppColors.success;
    if (type == InAppNotificationType.caution) return AppColors.caution;
    if (type == InAppNotificationType.error) return AppColors.error;

    return AppColors.info;
  }

  static String _notificationTitle(InAppNotificationType type) {
    if (type == InAppNotificationType.success) return 'Success';
    if (type == InAppNotificationType.caution) return 'Caution';
    if (type == InAppNotificationType.error) return 'Error';

    return 'Information';
  }

  static IconData _notificationIcon(InAppNotificationType type) {
    if (type == InAppNotificationType.success) {
      return Icons.check_circle_rounded;
    }

    if (type == InAppNotificationType.caution) {
      return Icons.warning_rounded;
    }

    if (type == InAppNotificationType.error) {
      return Icons.error_rounded;
    }

    return Icons.info_rounded;
  }
}
