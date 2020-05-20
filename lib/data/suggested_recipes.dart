import 'package:sourdough_calculator/data/recipe.dart';

Map<String, dynamic> recipe60Json = {
  "name": "60% Hydration",
  "flourAmount": 1000,
  "ingredients": [
    // Sourdough
    {
      "name": 'Sourdough',
      "percent": 0.20,
      "type": "sourdough",
      "valueBounds": [0.0, 60.0],
      "subIngredients": [
        // Sourdough >> Flour
        {
          "name": 'Flour in sourdough',
          "percent": 0.67,
          "type": "flour",
          "valueBounds": [0.0, 100.0],
        },
        // Sourdough >> Water inside
        {
          "name": 'Water in sourdough',
          "percent": 0.33,
          "type": "water",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Flour
    {
      "name": 'Flour',
      "percent": 1.0,
      "type": "flour",
      "valueBounds": null,
      "subIngredients": [
        // Flour >> White Flour
        {
          "name": 'White Flour',
          "percent": 1.0,
          "type": "whiteFlour",
          "valueBounds": [0.0, 100.0],
        },
        // Flour >> Whole-wheat Flour
        {
          "name": 'Whole-wheat Flour',
          "percent": 0.0,
          "type": "wholeFlour",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Water
    {
      "name": 'Water',
      "percent": 0.60,
      "type": "water",
      "valueBounds": [50.0, 120.0],
    },
    // Salt
    {
      "name": 'Salt',
      "percent": 0.02,
      "type": "salt",
      "valueBounds": [0.0, 10.0],
    }
  ],
};

Map<String, dynamic> recipe70Json = {
  "name": "70% Hydration",
  "flourAmount": 1000,
  "ingredients": [
    // Sourdough
    {
      "name": 'Sourdough',
      "percent": 0.20,
      "type": "sourdough",
      "valueBounds": [0.0, 60.0],
      "subIngredients": [
        // Sourdough >> Flour
        {
          "name": 'Flour in sourdough',
          "percent": 0.67,
          "type": "flour",
          "valueBounds": [0.0, 100.0],
        },
        // Sourdough >> Water inside
        {
          "name": 'Water in sourdough',
          "percent": 0.33,
          "type": "water",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Flour
    {
      "name": 'Flour',
      "percent": 1.0,
      "type": "flour",
      "valueBounds": null,
      "subIngredients": [
        // Flour >> White Flour
        {
          "name": 'White Flour',
          "percent": 1.0,
          "type": "whiteFlour",
          "valueBounds": [0.0, 100.0],
        },
        // Flour >> Whole-wheat Flour
        {
          "name": 'Whole-wheat Flour',
          "percent": 0.0,
          "type": "wholeFlour",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Water
    {
      "name": 'Water',
      "percent": 0.70,
      "type": "water",
      "valueBounds": [50.0, 120.0],
    },
    // Salt
    {
      "name": 'Salt',
      "percent": 0.02,
      "type": "salt",
      "valueBounds": [0.0, 10.0],
    }
  ],
};

Map<String, dynamic> recipeWholeWheatJson = {
  "name": "Whole-wheat",
  "flourAmount": 1000,
  "ingredients": [
    // Sourdough
    {
      "name": 'Sourdough',
      "percent": 0.20,
      "type": "sourdough",
      "valueBounds": [0.0, 60.0],
      "subIngredients": [
        // Sourdough >> Flour
        {
          "name": 'Flour in sourdough',
          "percent": 0.67,
          "type": "flour",
          "valueBounds": [0.0, 100.0],
        },
        // Sourdough >> Water inside
        {
          "name": 'Water in sourdough',
          "percent": 0.33,
          "type": "water",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Flour
    {
      "name": 'Flour',
      "percent": 1.0,
      "type": "flour",
      "valueBounds": null,
      "subIngredients": [
        // Flour >> White Flour
        {
          "name": 'White Flour',
          "percent": 0.20,
          "type": "whiteFlour",
          "valueBounds": [0.0, 100.0],
        },
        // Flour >> Whole-wheat Flour
        {
          "name": 'Whole-wheat Flour',
          "percent": 0.80,
          "type": "wholeFlour",
          "valueBounds": [0.0, 100.0],
        }
      ],
    },
    // Water
    {
      "name": 'Water',
      "percent": 0.60,
      "type": "water",
      "valueBounds": [50.0, 120.0],
    },
    // Salt
    {
      "name": 'Salt',
      "percent": 0.02,
      "type": "salt",
      "valueBounds": [0.0, 10.0],
    }
  ],
};

Recipe recipe60 = Recipe.fromJson(recipe60Json);
Recipe recipe70 = Recipe.fromJson(recipe70Json);
Recipe recipeWholeWheat = Recipe.fromJson(recipeWholeWheatJson);

List<Recipe> suggestedRecipesList = <Recipe>[
  recipe60,
  recipe70,
  recipeWholeWheat,
];


