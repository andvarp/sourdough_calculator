import 'package:flutter/material.dart';
import 'package:sourdough_calculator/screens/home_screen.dart';
import 'package:sourdough_calculator/screens/login_screen.dart';
import 'package:sourdough_calculator/screens/unknown_screen.dart';

final String initialRoute = LoginScreen.route;
// login should be the first screen


class Router {
  static MaterialPageRoute materialPageRouteBuilder(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, MaterialPageRoute> routesConfig = {
      HomeScreen.route: materialPageRouteBuilder(HomeScreen()),
      LoginScreen.route: materialPageRouteBuilder(LoginScreen()),
      UnknownScreen.route: generateUnknownRoute(settings),
    };

    if (!routesConfig.containsKey(settings.name)) {
      return routesConfig[UnknownScreen.route];
    }

    return routesConfig[settings.name];
  }

  static Route<dynamic> generateUnknownRoute(RouteSettings settings) {
    return materialPageRouteBuilder(UnknownScreen(settings: settings));
  }
}
