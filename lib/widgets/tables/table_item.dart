import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_text_styles.dart';
import 'table_cell_item.dart';

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
