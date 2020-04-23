import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/utils.dart';

abstract class RecipeAbstract {
  int flourAmount;
  Map<IngredientType, Ingredient> ingredients;
  String toString();
}

class Recipe extends RecipeAbstract {
  Recipe({
    int flourAmount = kInitialFlourAMount,
    Map<IngredientType, Ingredient> ingredients =
        const <IngredientType, Ingredient>{},
  }) {
    this.flourAmount = flourAmount;
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
  }

  void setFlourAmount(int amount) {
    flourAmount = amount;
    computeValues();
  }

  void setIngredient(Ingredient ingredient, double percent, Ingredient parent) {
    if (parent == null) {
      ingredient.percent = percent;
    }
    if (parent != null && parent.subIngredients.length > 1) {
      List<IngredientType> subIngredientKeys = parent.subIngredients.keys
          .toList()
          .where((type) => type != ingredient.type)
          .toList();

      parent.subIngredients.forEach((type, subIngredient) {
        if (type == ingredient.type) {
          subIngredient.percent = percent;
        } else {
          subIngredient.percent =
              (setPercent(100) - percent) / subIngredientKeys.length;
        }
      });
    }

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

  bool checkIsValid() {
    double allPercents = 0;
    double allValues = 0;
    bool isValid;
    ingredients.forEach((type, ingredient) {
      if (type != IngredientType.sourdough) {
        allPercents += ingredient.percent;
      }
      allValues += ingredient.value;
    });

    isValid = allPercents * flourAmount == allValues;
    return isValid;
  }

  String toString() {
    String print = 'isValid? => ${checkIsValid()} \n';

    print += '**Flour amount => $flourAmount \n';

    ingredients.forEach((IngredientType type, Ingredient ingredient) {
      print +=
          '**Ingredient \'${ingredient.name}\' |${printPercent(ingredient.percent)}| => ${ingredient.value}gr \n';
      if (ingredient.subIngredients != null) {
        Map<IngredientType, Ingredient> subIngredients =
            ingredient.subIngredients;
        subIngredients
            .forEach((IngredientType subType, Ingredient subIngredient) {
          print +=
              '**\tSubIngredient \'${subIngredient.name}\' |${printPercent(subIngredient.percent)}| => ${subIngredient.value}gr\n';
        });
      }
    });

    return print;
  }
}
