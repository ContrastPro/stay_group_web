import 'package:easy_localization/easy_localization.dart';

class TranslateLocale {
  const TranslateLocale(
    this._localeRoute,
  );

  final String _localeRoute;

  String tr(
    String field, {
    List<String>? args,
  }) {
    return '$_localeRoute.$field'.tr(args: args ?? []);
  }
}
