import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';

class IconDropdown extends StatelessWidget {
  const IconDropdown({
    super.key,
    required this.initialData,
    this.labelText,
    required this.values,
    required this.onChanged,
  });

  final String? initialData;
  final String? labelText;
  final List<String> values;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3.5),
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.paragraphSMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 1.5),
        ],
        SizedBox(
          width: 90.0,
          child: CustomDropdown<String>(
            initialItem: initialData,
            items: values,
            closedHeaderPadding: const EdgeInsets.symmetric(
              vertical: 7.35,
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
            onChanged: (String? value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}