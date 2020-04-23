import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/utils.dart';

Recipe recipe60 = Recipe(
  flourAmount: 1000,
  ingredients: <IngredientType, Ingredient>{
    IngredientType.sourdough: Ingredient(
      name: 'Sourdough',
      percent: setPercent(30),
      type: IngredientType.sourdough,
      subIngredients: <IngredientType, Ingredient>{
        IngredientType.flour: Ingredient(
          name: 'Flour in sourdough',
          percent: setPercent(67),
          type: IngredientType.flour,
          valueBounds: [0, 100],
        ),
        IngredientType.water: Ingredient(
          name: 'Water in sourdough',
          percent: setPercent(33),
          type: IngredientType.water,
          valueBounds: [0, 100],
        )
      },
      valueBounds: [0.0, 60.0],
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
          valueBounds: [0, 100],
        ),
        IngredientType.wholeFlour: Ingredient(
          name: 'Wholemeal Flour',
          percent: setPercent(20),
          type: IngredientType.wholeFlour,
          valueBounds: [0, 100],
        ),
      },
      valueBounds: null,
    ),
    IngredientType.water: Ingredient(
      name: 'Water',
      percent: setPercent(60),
      type: IngredientType.water,
      valueBounds: [50.0, 120.0],
    ),
    IngredientType.salt: Ingredient(
      name: 'Salt',
      percent: setPercent(2),
      type: IngredientType.salt,
      valueBounds: [0.0, 10.0],
    ),
  },
);
