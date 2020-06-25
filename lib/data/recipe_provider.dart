import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/suggested_recipes.dart';
import 'package:sourdough_calculator/data/ingredient.dart';

class RecipeProvider extends ChangeNotifier {
  Recipe currentRecipe = recipe60;
  List<Recipe> suggestedRecipes = suggestedRecipesList;

  RecipeProvider() {
    loadInitialData();
  }

  void loadInitialData() async {
    await loadLocalStorage();
  }

  Future<void> loadLocalStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Turn this on when changing the attributes in Recipe class
    await preferences.clear();

    if (preferences.getString(kLSRecipe) == null) {
      currentRecipe = recipe60;
      return;
    }

    currentRecipe =
        Recipe.fromJson(json.decode(preferences.getString(kLSRecipe)));
    notifyListeners();
  }

  void safeToLocalStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kLSRecipe, json.encode(currentRecipe.toJson()));
  }

  void changeFlourAmount(int amount) {
    currentRecipe.setFlourAmount(amount);
    notifyListeners();
  }

  void changePercent(Ingredient ingredient, double percent, Ingredient parent) {
    currentRecipe.setIngredient(ingredient, percent, parent);
    notifyListeners();
  }

  void changeCurrentRecipe(Recipe newCurrentRecipe) {
    currentRecipe = newCurrentRecipe;
    safeToLocalStorage();
  }
}
