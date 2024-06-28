import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Inter';

  // [START] H1 - Heading

  static TextStyle get head1Bold => const TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.w700,
      );

  // [END] H1 - Heading

  // [START] H5 - Heading

  static TextStyle get head5SemiBold => const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
      );

  // [END] H5 - Heading

  // [START] Paragraph M

  static TextStyle get paragraphMBold => const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get paragraphMSemiBold => const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get paragraphMMedium => const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get paragraphMRegular => const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  // [END] Paragraph M

  // [START] Paragraph S

  static TextStyle get paragraphSBold => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get paragraphSSemiBold => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get paragraphSMedium => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get paragraphSRegular => const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      );

// [END] Paragraph S
}
