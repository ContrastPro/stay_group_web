import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Inter';

  static TextStyle get head1Bold => const TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get paragraphMRegular => const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get paragraphSMedium => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get paragraphSRegular => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      );
}
