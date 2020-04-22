import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/sourdough_provider.dart';
import 'package:sourdough_calculator/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SourdoughProvider(),
          ),
        ],
        child: Consumer<SourdoughProvider>(
          builder: (context, sourdoughProvider, _) {
            return MaterialApp(
              title: 'Sourdough calculator',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              home: HomeScreen(),
            );
          },
        ));
  }
}
