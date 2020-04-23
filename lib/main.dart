import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/app_lenguage_provider.dart';
import 'package:sourdough_calculator/home_screen.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';

void main() async {
  AppLanguageProvider appLanguage = AppLanguageProvider();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguageProvider appLanguage;

  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Sourdough calculator',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            supportedLocales: [
              Locale('en', 'US'),
              Locale('es', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
