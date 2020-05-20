import 'package:backdrop/backdrop.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:shake/shake.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/views/_old_results_view.dart';
import 'package:sourdough_calculator/views/_old_settings_screen.dart';
import 'package:sourdough_calculator/views/home_view.dart';

class HomeScreen extends StatefulWidget {
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

    return Scaffold(
      body: SafeArea(
        top: true,
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            allowImplicitScrolling: true,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              HomeView(),
              OldResultsView(),
              OldSettingsView(),
              Container(
                color: Colors.teal,
              ),
              Container(
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(index);
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
