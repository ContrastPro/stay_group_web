import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resources/app_colors.dart';
import '../navigation/custom_drawer.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({
    super.key,
    required this.state,
    required this.builder,
  });

  final GoRouterState state;
  final Widget Function(Size) builder;

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
            child: Row(
              children: [
                CustomDrawer(
                  fullPath: state.fullPath,
                  screenSize: size,
                ),
                const SizedBox(width: 12.0),
                Expanded(
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
                    child: builder(size),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
