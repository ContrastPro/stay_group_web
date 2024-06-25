import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../resources/app_text_styles.dart';
import '../utils/constants.dart';

enum InAppNotificationType { info, warning, error }

class InAppNotificationService {
  const InAppNotificationService._();

  static void show({
    String title = 'Info message',
    InAppNotificationType type = InAppNotificationType.info,
  }) {
    BotToast.showCustomNotification(
      onlyOne: true,
      duration: const Duration(
        milliseconds: 5000,
      ),
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      toastBuilder: (_) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: _notificationColor(type),
            borderRadius: kCircleRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 8.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 3.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _notificationIcon(type),
                  size: 18.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.paragraphSRegular.copyWith(
                      color: _notificationColorText(type),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _notificationColor(InAppNotificationType type) {
    if (type == InAppNotificationType.warning) return Colors.orangeAccent;
    if (type == InAppNotificationType.error) return Colors.redAccent;
    return Colors.white;
  }

  static Color _notificationColorText(InAppNotificationType type) {
    if (type == InAppNotificationType.info) return Colors.black54;
    return Colors.white;
  }

  static IconData _notificationIcon(InAppNotificationType type) {
    if (type == InAppNotificationType.warning) {
      return Icons.warning_rounded;
    }

    if (type == InAppNotificationType.error) {
      return Icons.error_rounded;
    }

    return Icons.done_rounded;
  }
}
