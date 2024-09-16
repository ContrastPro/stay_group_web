import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import 'table_cell_item.dart';

class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    this.height = 44.0,
    this.backgroundColor = AppColors.scaffoldSecondary,
    this.addBorder = false,
    this.borderRadius = BorderRadius.zero,
    required this.cells,
    this.onTap,
  });

  final double height;
  final Color backgroundColor;
  final bool addBorder;
  final BorderRadius borderRadius;
  final List<TableCellItem> cells;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(
          minHeight: height,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: addBorder
              ? const Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: AppColors.border,
                  ),
                )
              : null,
        ),
        child: Row(
          children: cells,
        ),
      ),
    );
  }
}
