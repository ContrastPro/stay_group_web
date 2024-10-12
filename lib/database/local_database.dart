import 'dart:async';
import 'dart:ui';

import 'package:hive/hive.dart';

class LocalDB {
  const LocalDB._();

  static const LocalDB instance = LocalDB._();

  static const String _localeBox = 'localeBox';

  Future<void> ensureInitialized() async {
    await _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.openBox<String>(_localeBox);
  }

  Future<void> saveLocale(Locale locale) async {
    final Box<String> localeBox = Hive.box(_localeBox);

    await localeBox.put('locale', locale.toLanguageTag());
  }

  Future<Locale?> getLocale() async {
    final Box<String> localeBox = Hive.box(_localeBox);

    final String? response = localeBox.get('locale');

    if (response != null) {
      return Locale(response);
    }

    return null;
  }
}
