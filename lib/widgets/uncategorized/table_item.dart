import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';

class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    this.height = 44.0,
    this.backgroundColor = AppColors.scaffoldSecondary,
    this.borderRadius = BorderRadius.zero,
    required this.cells,
  });

  final double height;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final List<TableCellItem> cells;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: height,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: cells,
      ),
    );
  }
}

class TableCellItem extends StatelessWidget {
  const TableCellItem({
    super.key,
    this.flex = 1,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.alignment = Alignment.centerLeft,
    this.title,
    this.child,
  }) : assert(title != null || child != null);

  final int flex;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final String? title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: padding,
        alignment: alignment,
        child: title != null
            ? Text(
                title!,
                style: AppTextStyles.paragraphSMedium,
              )
            : child,
      ),
    );
  }
}
