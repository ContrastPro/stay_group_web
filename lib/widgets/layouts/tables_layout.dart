import 'package:flutter/material.dart';

class TablesLayout extends StatelessWidget {
  const TablesLayout({
    super.key,
    required this.header,
    required this.body,
  });

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 32.0,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: header,
          ),
          const SizedBox(height: 24.0),
          Expanded(child: body),
        ],
      ),
    );
  }
}
