import 'package:flutter/material.dart';
import 'package:sourdough_calculator/i18n/locale_enum.dart';

const kDefaultLocale = Locale('en');
const kSupportedLanguageCodes = ['en', 'es'];
const kSupportedLocalesMap = {
  LocaleEnum.en: Locale('en', 'US'),
  LocaleEnum.es: Locale('es', ''),
};

const languageCodeStoreKey = 'language_code';
const countryCodeStoreKey = 'countryCode';
