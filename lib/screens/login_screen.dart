import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/auth_provider.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/screens/home_screen.dart';
import 'package:sourdough_calculator/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static String route = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ButtonState buttonState = ButtonState.idle;

  void navigateToHomeScreen(BuildContext context) {
    Navigator.popAndPushNamed(context, HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!(authProvider?.isFirstLogin ?? true) &&
        (authProvider?.isLoggedIn() ?? false)) {
      scheduleMicrotask(() => navigateToHomeScreen(context));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'login_icon',
              child: Container(
                height: 200.0,
//                child: Image.asset('images/logo.png'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesome5.bread_slice,
                      size: 40,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 20),
                    Text('Sourdough Calculator'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            ProgressButton(
              radius: 100.0,
              progressIndicator: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              progressIndicatorAligment: MainAxisAlignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              stateWidgets: {
                ButtonState.idle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Image.asset(
                        'assets/images/google_logo.png',
                        height: 35,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Log In with Google",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                ButtonState.loading: Container(),
                ButtonState.fail: Text("Error",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
                ButtonState.success: Text("Success",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500))
              },
              stateColors: {
                ButtonState.idle: Colors.white,
                ButtonState.loading: Color(0xff4285F4),
                ButtonState.fail: Colors.deepOrangeAccent,
                ButtonState.success: Color(0xff4285F4),
              },
              onPressed: () {
                if (buttonState == ButtonState.idle) {
                  setState(() {
                    buttonState = ButtonState.loading;
                  });
                  authProvider.signIn().then((value) {
                    setState(() {
                      buttonState =
                          value ? ButtonState.success : ButtonState.fail;
                    });
                    navigateToHomeScreen(context);
                  });
                }
              },
              state: buttonState,
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String text;

  RoundedButton(
      {@required this.text, @required this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black38),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
