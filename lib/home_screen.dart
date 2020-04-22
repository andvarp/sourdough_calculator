import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:sourdough_calculator/views/results_view.dart';
import 'package:sourdough_calculator/views/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackdropScaffold(
        title: Text(
          'Sourdough Calculator',
          style: Theme.of(context).textTheme.subhead,
        ),
        backLayer: SettingsView(),
        frontLayer: ResultsView(),
        iconPosition: BackdropIconPosition.none,
        actions: <Widget>[
          BackdropToggleButton(icon: AnimatedIcons.arrow_menu),
        ],
      ),
    );
  }
}
