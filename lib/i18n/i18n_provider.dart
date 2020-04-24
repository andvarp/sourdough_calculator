import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourdough_calculator/i18n/i18n_contants.dart';

class I18nProvider extends ChangeNotifier {
  I18nProvider() {
    fetchLocale();
  }

  Locale _appLocale = kDefaultLocale;
  Locale get appLocal => _appLocale ?? kDefaultLocale;

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString(languageCodeStoreKey) == null) {
      _appLocale = kDefaultLocale;
      return Null;
    }

    _appLocale = Locale(prefs.getString(languageCodeStoreKey));
    return Null;
  }

  void changeLanguage(Locale type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_appLocale == type) {
      return;
    }

    if (type == Locale("es")) {
      _appLocale = Locale("es");
      await prefs.setString(languageCodeStoreKey, 'es');
      await prefs.setString(countryCodeStoreKey, '');
    } else {
      _appLocale = Locale("en");
      await prefs.setString(languageCodeStoreKey, 'en');
      await prefs.setString(countryCodeStoreKey, 'US');
    }

    notifyListeners();
  }
}
