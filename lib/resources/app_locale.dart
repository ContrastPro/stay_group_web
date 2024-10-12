import 'package:flutter/material.dart';

import '../models/uncategorized/locale_model.dart';

class AppLocale {
  const AppLocale._();

  static const String path = 'assets/translations';

  static const Locale fallbackLocale = Locale('en', 'US');

  static const List<LocaleModel> supportedLocales = [
    LocaleModel(
      locale: Locale('en', 'US'),
      name: 'English',
    ),
    LocaleModel(
      locale: Locale('ru', 'RU'),
      name: 'Русский',
    ),
  ];

  static List<Locale> get getSupportedLocales {
    return supportedLocales.map((e) => e.locale).toList();
  }
}
