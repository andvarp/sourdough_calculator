import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/auth_provider.dart';
import 'package:sourdough_calculator/i18n/i18n_provider.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/router.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/i18n/i18n_constants.dart';

//import 'package:expandable/expandable.dart';
//import 'dart:math' as math;

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  //  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: recordError);
}

Future<void> recordError(dynamic exception, StackTrace stack, {dynamic context}) async {
  logger.e(exception);
  logger.e(stack);
  logger.e(context);
  Crashlytics.instance.recordError(exception, stack, context: context);
}

// TODO: Use this in the headlines
// https://pub.dev/packages/auto_size_text

// TODO: Use this when loading data
// https://pub.dev/packages/shimmer#-example-tab-

// TODO: Add this feature
// https://pub.dev/packages/wakelock

// TODO: Implement this Oauth with apple
// https://pub.dev/packages/sign_in_with_apple

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => I18nProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: Consumer<I18nProvider>(
        builder: (context, i18nProvider, _) {
          return MaterialApp(
            title: 'Sourdough calculator',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            locale: i18nProvider.appLocal,
            supportedLocales: kSupportedLocalesMap.values.toList(),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              I18nDelegate(i18nProvider.appLocal),
            ],
            initialRoute: initialRoute,
            onGenerateRoute: Router.generateRoute,
            onUnknownRoute: Router.generateUnknownRoute,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          );
        },
      ),
    );
  }
}

/// https://pub.dev/packages/expandable#-example-tab-

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Expandable Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  @override
//  State createState() {
//    return MyHomePageState();
//  }
//}
//
//class MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Expandable Demo"),
//      ),
//      body: ExpandableTheme(
//        data:
//        const ExpandableThemeData(
//          iconColor: Colors.blue,
//          useInkWell: true,
//        ),
//        child: ListView(
//          physics: const BouncingScrollPhysics(),
//          children: <Widget>[
//            Card1(),
//            Card2(),
//            Card3(),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//const loremIpsum =
//    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//
//class Card1 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ExpandableNotifier(
//        child: Padding(
//          padding: const EdgeInsets.all(10),
//          child: Card(
//            clipBehavior: Clip.antiAlias,
//            child: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: 150,
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: Colors.orange,
//                      shape: BoxShape.rectangle,
//                    ),
//                  ),
//                ),
//                ScrollOnExpand(
//                  scrollOnExpand: true,
//                  scrollOnCollapse: false,
//                  child: ExpandablePanel(
//                    theme: const ExpandableThemeData(
//                      headerAlignment: ExpandablePanelHeaderAlignment.center,
//                      tapBodyToCollapse: true,
//                    ),
//                    header: Padding(
//                        padding: EdgeInsets.all(10),
//                        child: Text(
//                          "ExpandablePanel",
//                          style: Theme.of(context).textTheme.body2,
//                        )),
//                    collapsed: Text(
//                      loremIpsum,
//                      softWrap: true,
//                      maxLines: 2,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                    expanded: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        for (var _ in Iterable.generate(5))
//                          Padding(
//                              padding: EdgeInsets.only(bottom: 10),
//                              child: Text(
//                                loremIpsum,
//                                softWrap: true,
//                                overflow: TextOverflow.fade,
//                              )),
//                      ],
//                    ),
//                    builder: (_, collapsed, expanded) {
//                      return Padding(
//                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                        child: Expandable(
//                          collapsed: collapsed,
//                          expanded: expanded,
//                          theme: const ExpandableThemeData(crossFadePoint: 0),
//                        ),
//                      );
//                    },
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ));
//  }
//}
//
//class Card2 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    buildImg(Color color, double height) {
//      return SizedBox(
//          height: height,
//          child: Container(
//            decoration: BoxDecoration(
//              color: color,
//              shape: BoxShape.rectangle,
//            ),
//          ));
//    }
//
//    buildCollapsed1() {
//      return Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.all(10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Expandable",
//                    style: Theme.of(context).textTheme.body1,
//                  ),
//                ],
//              ),
//            ),
//          ]);
//    }
//
//    buildCollapsed2() {
//      return buildImg(Colors.lightGreenAccent, 150);
//    }
//
//    buildCollapsed3() {
//      return Container();
//    }
//
//    buildExpanded1() {
//      return Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.all(10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Expandable",
//                    style: Theme.of(context).textTheme.body1,
//                  ),
//                  Text(
//                    "3 Expandable widgets",
//                    style: Theme.of(context).textTheme.caption,
//                  ),
//                ],
//              ),
//            ),
//          ]);
//    }
//
//    buildExpanded2() {
//      return Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Expanded(child: buildImg(Colors.lightGreenAccent, 100)),
//              Expanded(child: buildImg(Colors.orange, 100)),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//              Expanded(child: buildImg(Colors.lightBlue, 100)),
//              Expanded(child: buildImg(Colors.cyan, 100)),
//            ],
//          ),
//        ],
//      );
//    }
//
//    buildExpanded3() {
//      return Padding(
//        padding: EdgeInsets.all(10),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(
//              loremIpsum,
//              softWrap: true,
//            ),
//          ],
//        ),
//      );
//    }
//
//    return ExpandableNotifier(
//        child: Padding(
//          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//          child: ScrollOnExpand(
//            child: Card(
//              clipBehavior: Clip.antiAlias,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Expandable(
//                    collapsed: buildCollapsed1(),
//                    expanded: buildExpanded1(),
//                  ),
//                  Expandable(
//                    collapsed: buildCollapsed2(),
//                    expanded: buildExpanded2(),
//                  ),
//                  Expandable(
//                    collapsed: buildCollapsed3(),
//                    expanded: buildExpanded3(),
//                  ),
//                  Divider(
//                    height: 1,
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Builder(
//                        builder: (context) {
//                          var controller = ExpandableController.of(context);
//                          return FlatButton(
//                            child: Text(
//                              controller.expanded ? "COLLAPSE" : "EXPAND",
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .button
//                                  .copyWith(color: Colors.deepPurple),
//                            ),
//                            onPressed: () {
//                              controller.toggle();
//                            },
//                          );
//                        },
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ));
//  }
//}
//
//class Card3 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    buildItem(String label) {
//      return Padding(
//        padding: const EdgeInsets.all(10.0),
//        child: Text(label),
//      );
//    }
//
//    buildList() {
//      return Column(
//        children: <Widget>[
//          for (var i in [1, 2, 3, 4]) buildItem("Item ${i}"),
//        ],
//      );
//    }
//
//    return ExpandableNotifier(
//        child: Padding(
//          padding: const EdgeInsets.all(10),
//          child: ScrollOnExpand(
//            child: Card(
//              clipBehavior: Clip.antiAlias,
//              child: Column(
//                children: <Widget>[
//                  ExpandablePanel(
//                    theme: const ExpandableThemeData(
//                      headerAlignment: ExpandablePanelHeaderAlignment.center,
//                      tapBodyToExpand: true,
//                      tapBodyToCollapse: true,
//                      hasIcon: false,
//                    ),
//                    header: Container(
//                      color: Colors.indigoAccent,
//                      child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Row(
//                          children: [
//                            ExpandableIcon(
//                              theme: const ExpandableThemeData(
//                                expandIcon: Icons.arrow_right,
//                                collapseIcon: Icons.arrow_drop_down,
//                                iconColor: Colors.white,
//                                iconSize: 28.0,
//                                iconRotationAngle: math.pi / 2,
//                                iconPadding: EdgeInsets.only(right: 5),
//                                hasIcon: false,
//                              ),
//                            ),
//                            Expanded(
//                              child: Text(
//                                "Items",
//                                style: Theme.of(context)
//                                    .textTheme
//                                    .body2
//                                    .copyWith(color: Colors.white),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                    expanded: buildList(),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ));
//  }
//}