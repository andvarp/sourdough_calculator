import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourdough_calculator/i18n/i18n_constants.dart';

class I18nProvider extends ChangeNotifier {
  I18nProvider() {
    loadInitialData();
  }

  Locale _appLocale = kDefaultLocale;
  Locale get appLocal => _appLocale ?? kDefaultLocale;

  void loadInitialData() async {
    await fetchLocale();
    notifyListeners();
  }

  fetchLocale() async {
    var preferences = await SharedPreferences.getInstance();

    if (preferences.getString(languageCodeStoreKey) == null) {
      _appLocale = kDefaultLocale;
      return Null;
    }

    _appLocale = Locale(preferences.getString(languageCodeStoreKey));
    return Null;
  }

  void changeLanguage(Locale type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (_appLocale == type) {
      return;
    }

    if (type == Locale("es")) {
      _appLocale = Locale("es");
      await preferences.setString(languageCodeStoreKey, 'es');
      await preferences.setString(countryCodeStoreKey, '');
    } else {
      _appLocale = Locale("en");
      await preferences.setString(languageCodeStoreKey, 'en');
      await preferences.setString(countryCodeStoreKey, 'US');
    }

    notifyListeners();
  }
}
