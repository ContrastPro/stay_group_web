import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../models/calculations/calculation_extra_model.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_icons.dart';
import '../../../../resources/app_text_styles.dart';

class ManageCalculationExtraItem extends StatelessWidget {
  const ManageCalculationExtraItem({
    super.key,
    required this.currency,
    required this.calculationExtra,
    required this.onManage,
  });

  final String currency;
  final CalculationExtraModel calculationExtra;
  final void Function(CalculationExtraModel) onManage;

  String _getFormatDate() {
    final DateFormat dateFormat = DateFormat('dd/MM/yy');
    return dateFormat.format(calculationExtra.date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldSecondary,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: AppColors.regularShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  calculationExtra.name,
                  style: AppTextStyles.paragraphSMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16.0),
              GestureDetector(
                onTap: () => onManage(calculationExtra),
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  AppIcons.edit,
                  width: 22.0,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$currency${calculationExtra.priceVal}',
                style: AppTextStyles.paragraphMRegular,
              ),
              const SizedBox(width: 12.0),
              Text(
                _getFormatDate(),
                style: AppTextStyles.paragraphMRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
