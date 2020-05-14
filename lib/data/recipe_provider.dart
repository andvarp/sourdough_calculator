import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/suggested_recipes.dart';
import 'package:sourdough_calculator/data/ingredient.dart';

class RecipeProvider extends ChangeNotifier {
  Recipe recipe = recipe60;

  RecipeProvider() {
    loadInitialData();
  }

  void loadInitialData() async{
    await loadLocalStorage();
  }

  Future<void> loadLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('RECIPE') == null) {
      recipe = recipe60;
      return;
    }

    recipe = Recipe.fromJson(json.decode(prefs.getString('RECIPE')));
    notifyListeners();

  }

  void safeToLocalStorage () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('RECIPE', json.encode(recipe.toJson()));
  }

  void changeFlourAmount(int amount) {
    recipe.setFlourAmount(amount);
    notifyListeners();
  }

  void changePercent(Ingredient ingredient, double percent, Ingredient parent) {
    recipe.setIngredient(ingredient, percent, parent);
    notifyListeners();
  }
}
