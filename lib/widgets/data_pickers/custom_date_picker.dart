import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../../utils/helpers.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.labelText,
    required this.hintText,
    required this.onChanged,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? labelText;
  final String hintText;
  final void Function(DateTime) onChanged;

  Future<void> _showDatePicker(BuildContext context) async {
    const Duration day = Duration(days: 1);
    final DateTime now = currentTime();
    final DateTime maxYears = DateTime(now.year + 30);

    final DateTime first = firstDate != null ? firstDate!.add(day) : now;
    final DateTime last = lastDate != null ? lastDate!.subtract(day) : maxYears;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: first,
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  String _getFormatDate() {
    if (initialDate != null) {
      final DateFormat dateFormat = DateFormat('dd/MM/yy');
      return dateFormat.format(initialDate!);
    }

    return hintText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.paragraphSMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4.0),
        ],
        GestureDetector(
          onTap: () => _showDatePicker(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: 40.5,
            decoration: BoxDecoration(
              color: AppColors.scaffoldSecondary,
              border: Border.all(
                color: AppColors.border,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: AppColors.regularShadow,
            ),
            child: Row(
              children: [
                const SizedBox(width: 12.0),
                SvgPicture.asset(
                  AppIcons.calendar,
                  width: 22.0,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  _getFormatDate(),
                  style: AppTextStyles.paragraphMRegular.copyWith(
                    color: AppColors.iconPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
