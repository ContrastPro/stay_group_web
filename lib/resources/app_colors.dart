import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF141C25);
  static const Color secondary = Color(0xFF344051);

  static const Color scaffoldPrimary = Color(0xFFF9FAFB);
  static const Color scaffoldSecondary = Color(0xFFFCFEFF);

  static const Color textPrimary = Color(0xFF141C25);
  static const Color textSecondary = Color(0xFF344051);

  static const Color iconPrimary = Color(0xFF637083);
  //static const Color iconSecondary = Color(0xFF637083);

  static const Color border = Color(0xFFE4E7EC);
  static const Color error = Color(0xFFDE1212);
  static const Color transparent = Color(0x00000000);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.05),
      blurRadius: 50.0,
      offset: const Offset(0.0, 14.0),
      spreadRadius: 0.0,
    ),
  ];

  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.05),
      blurRadius: 2.0,
      offset: const Offset(0.0, 1.0),
      spreadRadius: 0.0,
    ),
  ];
}
