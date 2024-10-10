import 'package:flutter/material.dart';

class AppLocale {
  const AppLocale._();

  static const String path = 'assets/translations';

  static const Locale fallbackLocale = Locale('en', 'US');

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ru', 'RU'), // Russian
  ];
}
