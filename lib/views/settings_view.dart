import 'package:flutter/material.dart';
import 'package:sourdough_calculator/i18n/sample_change_locale.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 10.0,
            ),
            SampleChangeLocale(),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
