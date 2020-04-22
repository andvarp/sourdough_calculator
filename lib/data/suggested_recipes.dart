import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/utils.dart';

Recipe recipe60 = Recipe(
  ingredients: <IngredientType, Ingredient>{
    IngredientType.sourdough: Ingredient(
      name: 'Sourdough',
      percent: setPercent(20),
      type: IngredientType.sourdough,
      subIngredients: <IngredientType, Ingredient>{
        IngredientType.flour: Ingredient(
          name: 'Flour in sourdough',
          percent: setPercent(67),
          type: IngredientType.flour,
        ),
        IngredientType.water: Ingredient(
          name: 'Water in sourdough',
          percent: setPercent(33),
          type: IngredientType.water,
        )
      },
    ),
    IngredientType.flour: Ingredient(
      name: 'Flour',
      percent: setPercent(100),
      type: IngredientType.flour,
      subIngredients: <IngredientType, Ingredient>{
        IngredientType.whiteFlour: Ingredient(
          name: 'White Flour',
          percent: setPercent(80),
          type: IngredientType.whiteFlour,
        ),
        IngredientType.wholeFlour: Ingredient(
          name: 'Wholemeal Flour',
          percent: setPercent(20),
          type: IngredientType.wholeFlour,
        ),
      },
    ),
    IngredientType.water: Ingredient(
      name: 'Water',
      percent: setPercent(60),
      type: IngredientType.water,
    ),
    IngredientType.salt: Ingredient(
      name: 'Salt',
      percent: setPercent(2),
      type: IngredientType.salt,
    ),
  },
);
