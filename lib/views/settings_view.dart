import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/auth_provider.dart';
import 'package:sourdough_calculator/data/suggested_recipes.dart';
import 'package:sourdough_calculator/i18n/sample_change_locale.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/screens/login_screen.dart';
import 'package:sourdough_calculator/services/auth_service.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Firestore.instance
        .collection('talks')
        .document('document-name')
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
    });

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
              height: 60.0,
            ),
            authProvider.currentUser?.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      authProvider.currentUser.photoUrl,
                    ),
                    radius: 60,
                    backgroundColor: Colors.transparent,
                  )
                : Container(),
            Text(authProvider.currentUser?.displayName ?? ''),
            Text(authProvider.currentUser?.email ?? ''),
            Text(authProvider.getUID() ?? ''),
            RaisedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
                scheduleMicrotask(() =>
                    Navigator.popAndPushNamed(context, LoginScreen.route));
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 60.0),
            RaisedButton(
              child: const Text('Record Error'),
              onPressed: () {
                try {
                  throw 'error_example';
                } catch (e, s) {
                  // "context" will append the word "thrown" in the
                  // Crashlytics console.
                  Crashlytics.instance
                      .recordError(e, s, context: 'as an example');
                }
              },
            ),
            SizedBox(height: 60.0),
            RaisedButton(
              child: Text('Store in DB'),
              onPressed: () {
                Firestore.instance
                    .collection('Recipes')
                    .document()
                    .setData(recipeHoneyRaisinsJson);
              },
            ),

          ],
        ),
      ),
    );
  }
}
