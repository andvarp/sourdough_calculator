import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/utils.dart';

abstract class RecipeAbstract {
  int flourAmount = kInitialFlourAMount;
  Map<IngredientType, Ingredient> ingredients;
  String toString();
}

class Recipe extends RecipeAbstract {
  Recipe({
    Map<IngredientType, Ingredient> ingredients =
        const <IngredientType, Ingredient>{},
  }) {
    this.ingredients = ingredients;

    computeValues();
  }

  void computeValues() {
    ingredients.forEach((type, ingredient) {
      switch (type) {
        case IngredientType.sourdough:
          ingredient.value = flourAmount * ingredient.percent;
          break;
        case IngredientType.flour:
          double sourdoughFlour = ingredients[IngredientType.sourdough]
              .subIngredients[IngredientType.flour]
              .value;
          ingredient.value =
              (flourAmount * ingredient.percent) - sourdoughFlour;
          break;
        case IngredientType.water:
          double sourdoughWater = ingredients[IngredientType.sourdough]
              .subIngredients[IngredientType.water]
              .value;
          ingredient.value =
              (flourAmount * ingredient.percent) - sourdoughWater;
          break;

        case IngredientType.salt:
        default:
          ingredient.value = flourAmount * ingredient.percent;
          break;
      }
      computeSubIngredients(ingredient.value, ingredient.subIngredients);
    });

    print(this);
  }

  void setFlourAmount(int amount) {
    flourAmount = amount;
    computeValues();
  }

  void computeSubIngredients(double mainIngredientValue,
      Map<IngredientType, Ingredient> subIngredients) {
    if (subIngredients != null) {
      subIngredients.forEach((subType, subIngredient) {
        subIngredient.value =
            roundValueToDouble(mainIngredientValue * subIngredient.percent);
      });
    }
  }

  String toString() {
    String print = '**Flour amount => $flourAmount \n';

    ingredients.forEach((IngredientType type, Ingredient ingredient) {
      print +=
          '**Ingredient \'${ingredient.name}\' => ${ingredient.value}gr \n';
      if (ingredient.subIngredients != null) {
        Map<IngredientType, Ingredient> subIngredients =
            ingredient.subIngredients;
        subIngredients
            .forEach((IngredientType subType, Ingredient subIngredient) {
          print +=
              '**\tSubIngredient \'${subIngredient.name}\' => ${subIngredient.value}gr\n';
        });
      }
    });

    return print;
  }
}
