import 'package:flutter/material.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/suggested_recipes.dart';
import 'package:sourdough_calculator/data/ingredient.dart';

class RecipeProvider extends ChangeNotifier {
  Recipe recipe = recipe60;

  void changeFlourAmount(int amount) {
    recipe.setFlourAmount(amount);
    notifyListeners();
  }

  void changePercent(Ingredient ingredient, double percent, Ingredient parent) {
//    ingredient.percent = percent;
//    recipe.computeValues();
    recipe.setIngredient(ingredient, percent, parent);

    notifyListeners();
  }
}
