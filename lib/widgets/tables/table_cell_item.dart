import 'package:flutter/material.dart';

import '../../resources/app_text_styles.dart';

class TableCellItem extends StatelessWidget {
  const TableCellItem({
    super.key,
    this.flex = 1,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 6.0,
      vertical: 8.0,
    ),
    this.alignment = Alignment.centerLeft,
    this.title,
    this.textAlign = TextAlign.center,
    this.maxLines = 2,
    this.child,
  }) : assert(title != null || child != null);

  final int flex;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final String? title;
  final TextAlign textAlign;
  final int maxLines;
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
                textAlign: textAlign,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              )
            : child,
      ),
    );
  }
}
