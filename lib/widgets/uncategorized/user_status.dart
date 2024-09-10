import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
              archived ? 'Inactive' : 'Active',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
