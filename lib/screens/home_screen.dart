import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:sourdough_calculator/data/auth_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/screens/login_screen.dart';
import 'package:sourdough_calculator/views/home_view.dart';
import 'package:sourdough_calculator/views/recipe_edit_view.dart';
import 'package:sourdough_calculator/views/recipe_view.dart';
import 'package:sourdough_calculator/views/settings_view.dart';

class HomeScreen extends StatefulWidget {
  static String route = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController;
  ShakeDetector _detector;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _detector = ShakeDetector.autoStart(onPhoneShake: () {
      logger.d('Shake!!!!!');
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Shake!!!!!')));
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _detector.stopListening();
    super.dispose();
  }

  Widget build(BuildContext context) {
    I18n i18n = I18n.of(context);

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn()) {
      scheduleMicrotask(() => Navigator.popAndPushNamed(context, LoginScreen.route));
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            allowImplicitScrolling: true,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              HomeView(),
              RecipeView(),
              RecipeEditView(),
              SettingsView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.decelerate,);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text(i18n.translate('nav_bar_item_home')),
            icon: Icon(Icons.home),
            inactiveColor: Colors.blue.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            title: Text(i18n.translate('nav_bar_item_bread')),
            icon: Icon(
              FontAwesome5.bread_slice,
              size: 20,
            ),
            inactiveColor: Colors.deepOrange.withOpacity(0.7),
            activeColor: Colors.deepOrange,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            title: Text(i18n.translate('nav_bar_item_timer')),
            icon: Icon(Icons.access_alarms),
            inactiveColor: Colors.teal.withOpacity(0.7),
            activeColor: Colors.teal,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            title: Text(i18n.translate('nav_bar_item_settings')),
            icon: Icon(Icons.settings),
            inactiveColor: Colors.blueGrey.withOpacity(0.7),
            activeColor: Colors.blueGrey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
