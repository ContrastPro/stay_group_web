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
    required this.addDay,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.labelText,
    required this.hintFormat,
    required this.onChanged,
  });

  final bool addDay;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? labelText;
  final String hintFormat;
  final void Function(DateTime) onChanged;

  static const Duration _day = Duration(days: 1);

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime firstDate = _getFirstDate();
    final DateTime lastDate = _getLastDate();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  DateTime _getFirstDate() {
    final DateTime now = currentTime();

    if (firstDate != null) {
      return firstDate!.add(_day);
    }

    if (addDay) {
      return now.add(_day);
    }

    return now;
  }

  DateTime _getLastDate() {
    final DateTime now = currentTime();
    final DateTime maxYears = DateTime(now.year + 30);

    if (lastDate != null) {
      return lastDate!.subtract(_day);
    }

    return maxYears;
  }

  String _getFormatDate() {
    if (initialDate != null) {
      final DateFormat dateFormat = DateFormat(hintFormat);
      return dateFormat.format(initialDate!);
    }

    return hintFormat;
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
