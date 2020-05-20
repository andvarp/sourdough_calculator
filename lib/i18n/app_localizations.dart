import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sourdough_calculator/i18n/i18n_contants.dart';

class I18n {
  I18n(this.locale);

  Map<String, String> _localizedStrings;
  final Locale locale;

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  Future<bool> load() async {
    String jsonI18n =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonI18n);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    String value = _localizedStrings[key] ?? "<no-key-found>";
    assert(value != "<no-key-found>");
    return value;
  }


}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  I18nDelegate(this.locale);

  final Locale locale;

  @override
  bool isSupported(Locale locale) {
    return kSupportedLanguageCodes.contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) async {
    I18n localizations = new I18n(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
