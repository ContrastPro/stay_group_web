import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../utils/translate_locale.dart';

const TranslateLocale _locale = TranslateLocale('system');

class UserStatus extends StatelessWidget {
  const UserStatus({
    super.key,
    required this.archived,
  });

  final bool archived;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: archived ? AppColors.error : AppColors.success,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              _locale.tr(
                archived ? 'inactive' : 'active',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
