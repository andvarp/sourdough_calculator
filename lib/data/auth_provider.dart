import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseUser currentUser;
  bool isFirstLogin;

  AuthProvider(){
    loadInitialValues();
  }

  void loadInitialValues() async{
    isFirstLogin = await getIsFirstLogin();

    if (!isFirstLogin) {
      await signIn();
    }
    else{
      notifyListeners();
    }
  }

  Future<bool> signIn(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      currentUser = await signInWithGoogle(context);
    } catch (error) {
      currentUser = null;
    }

    preferences.setBool(kLSAuth, currentUser != null);

    notifyListeners();

    return currentUser != null;
  }

  void signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    signInWithGoogle();
    currentUser = null;

    preferences.setBool(kLSAuth, currentUser != null);

    notifyListeners();
  }

  Future<bool> getIsFirstLogin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool firstLogin = preferences.getBool(kLSAuth);

    return firstLogin == true ? false : true;
  }

  bool isLoggedIn() {
    bool loggedIn = false;

    if(currentUser != null && currentUser.uid != null) {
      loggedIn = true;
    }

    return loggedIn;
  }

  String getUID() {
    return currentUser?.uid;
  }
}