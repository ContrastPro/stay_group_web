import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';

class AnimatedDropdown extends StatelessWidget {
  const AnimatedDropdown({
    super.key,
    this.hintText,
    required this.values,
    required this.onChanged,
  });

  final String? hintText;
  final List<String> values;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: hintText,
      items: values,
      closedHeaderPadding: const EdgeInsets.symmetric(
        vertical: 9.0,
        horizontal: 12.0,
      ),
      validateOnChange: false,
      decoration: CustomDropdownDecoration(
        closedFillColor: AppColors.scaffoldSecondary,
        closedBorder: Border.all(
          color: AppColors.border,
        ),
        closedBorderRadius: BorderRadius.circular(10.0),
        closedShadow: AppColors.regularShadow,
        expandedFillColor: AppColors.scaffoldPrimary,
        expandedBorderRadius: BorderRadius.circular(10.0),
        hintStyle: AppTextStyles.paragraphMRegular.copyWith(
          color: AppColors.iconPrimary,
        ),
        headerStyle: AppTextStyles.paragraphMRegular,
        listItemStyle: AppTextStyles.paragraphMRegular,
      ),
      onChanged: onChanged,
    );
  }
}
