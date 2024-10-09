import 'dart:developer';

import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../utils/constants.dart';

class PreviewLayout extends StatelessWidget {
  const PreviewLayout({
    super.key,
    required this.content,
    required this.preview,
  });

  final List<Widget> content;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final Size size = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          log('${size.width} x ${size.height}', name: 'Screen size');

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.scaffoldSecondary,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: size.width >= kLaptopScreenWidth
                  ? _Row(
                      screenSize: size,
                      content: content,
                      preview: preview,
                    )
                  : _Column(
                      screenSize: size,
                      content: content,
                      preview: preview,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.screenSize,
    required this.content,
    required this.preview,
  });

  final Size screenSize;
  final List<Widget> content;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: screenSize.width >= kDesktopScreenWidth ? 512.0 : 384.0,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width >= kDesktopScreenWidth ? 40.0 : 18.0,
              vertical: screenSize.width >= kDesktopScreenWidth ? 42.0 : 18.0,
            ),
            children: content,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.iconPrimary.withOpacity(0.04),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: screenSize.height - 22.0,
                ),
                child: Center(
                  child: preview,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({
    required this.screenSize,
    required this.content,
    required this.preview,
  });

  final Size screenSize;
  final List<Widget> content;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width >= kMobileScreenWidth ? 40.0 : 18.0,
        vertical: screenSize.width >= kMobileScreenWidth ? 42.0 : 18.0,
      ),
      children: content,
    );
  }
}
