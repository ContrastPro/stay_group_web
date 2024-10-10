import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class TableView extends StatelessWidget {
  const TableView({
    super.key,
    required this.screenSize,
    required this.header,
    required this.body,
  });

  final Size screenSize;
  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width >= kTabletScreenWidth
            ? 32.0
            : screenSize.width >= kMobileScreenWidth
                ? 16.0
                : 12.0,
      ).copyWith(
        top: screenSize.width >= kTabletScreenWidth
            ? 28.0
            : screenSize.width >= kMobileScreenWidth
                ? 16.0
                : 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: header,
          ),
          SizedBox(
            height: screenSize.width >= kTabletScreenWidth
                ? 24.0
                : screenSize.width >= kMobileScreenWidth
                    ? 14.0
                    : 12.0,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
