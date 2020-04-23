import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/home_screen.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
