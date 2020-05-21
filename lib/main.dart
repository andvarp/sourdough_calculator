import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/i18n/i18n_provider.dart';
import 'package:sourdough_calculator/home_screen.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/i18n/i18n_contants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => I18nProvider()),
      ],
      child: Consumer<I18nProvider>(
        builder: (context, i18nProvider, _) {
          return MaterialApp(
            title: 'Sourdough calculator',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            locale: i18nProvider.appLocal,
            supportedLocales: kSupportedLocalesMap.values.toList(),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              I18nDelegate(i18nProvider.appLocal),
            ],
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
