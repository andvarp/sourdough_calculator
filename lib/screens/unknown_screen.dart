import 'package:flutter/material.dart';

class UnknownScreen extends StatefulWidget {
  static String route = 'unknown';
  final RouteSettings settings;

  UnknownScreen({this.settings});

  @override
  _UnknownScreenState createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'No route defined for ',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              widget.settings.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
