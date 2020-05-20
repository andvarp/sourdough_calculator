import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/utils.dart';

abstract class RecipeAbstract {
  String name;
  int flourAmount;
  List<Ingredient> ingredients;
  String toString();
}

class Recipe extends RecipeAbstract{
  Recipe({
    String name = "",
    int flourAmount = kInitialFlourAMount,
    List<Ingredient> ingredients = const <Ingredient>[],
  }) {
    this.name = name;
    this.flourAmount = flourAmount;
    this.ingredients = ingredients;

    computeValues();
  }

  Map<IngredientType, Ingredient> getIngredientsMap (List<Ingredient> ingredients) {
    Map<IngredientType, Ingredient> map = new Map<IngredientType, Ingredient>();
    if (ingredients != null) {
      ingredients.forEach((ingredient) {
        map[ingredient.type] = ingredient;
      });
    }
    return map;
  }

  void computeValues() {
    Map<IngredientType, Ingredient> ingredientsMap = getIngredientsMap(ingredients);
    Map<IngredientType, Ingredient> sourdoughSubIngredientsMap = getIngredientsMap(ingredientsMap[IngredientType.sourdough].subIngredients);

    ingredientsMap.forEach((type, ingredient) {
      switch (type) {
        case IngredientType.sourdough:
          ingredient.value = flourAmount * ingredient.percent;
          break;
        case IngredientType.flour:
          double sourdoughFlour = sourdoughSubIngredientsMap[IngredientType.flour].value;
          ingredient.value = (flourAmount * ingredient.percent) - sourdoughFlour;
          break;
        case IngredientType.water:
          double sourdoughWater = sourdoughSubIngredientsMap[IngredientType.water].value;
          ingredient.value = (flourAmount * ingredient.percent) - sourdoughWater;
          break;
        case IngredientType.salt:
        default:
          ingredient.value = flourAmount * ingredient.percent;
          break;
      }

      ingredient.subIngredients = computeSubIngredients(ingredient.value, getIngredientsMap(ingredientsMap[type].subIngredients));
    });

    ingredients = ingredientsMap.values.toList();
  }

  List<Ingredient> computeSubIngredients(double mainIngredientValue, Map<IngredientType, Ingredient> subIngredientsMap) {
    if (subIngredientsMap != null) {
      subIngredientsMap.forEach((subType, subIngredient) {
        subIngredient.value = roundValueToDouble(mainIngredientValue * subIngredient.percent);
      });
    }
    return subIngredientsMap.values.toList();
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
      Map<IngredientType, Ingredient> subIngredientsMap = getIngredientsMap(parent.subIngredients);
      List<IngredientType> subIngredientKeys = subIngredientsMap.keys
          .toList()
          .where((type) => type != ingredient.type)
          .toList();

      subIngredientsMap.forEach((type, subIngredient) {
        if (type == ingredient.type) {
          subIngredient.percent = percent;
        } else {
          subIngredient.percent =
              (setPercent(100) - percent) / subIngredientKeys.length;
        }
      });

      parent.subIngredients = subIngredientsMap.values.toList();
    }

    computeValues();
  }

  bool checkIsValid() {
    double allPercents = 0;
    double allValues = 0;
    bool isValid;
    getIngredientsMap(ingredients).forEach((type, ingredient) {
      if (type != IngredientType.sourdough) {
        allPercents += ingredient.percent;
      }
      allValues += ingredient.value;
    });

    isValid = allPercents * flourAmount == allValues;
    return isValid;
  }

  Recipe.fromJson(Map<String, dynamic> json) {
    assert(json['name'] != null);
    name = json['name'];

    assert(json['flourAmount'] != null);
    flourAmount = json['flourAmount'];

    if (json['ingredients'] != null) {
      ingredients = new List<Ingredient>();
      json['ingredients'].forEach((v) {
        ingredients.add(new Ingredient.fromJson(v));
      });
    }

    computeValues();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['flourAmount'] = this.flourAmount;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toString() {
    return toJson().toString() + '\nIs Valid >> ' + checkIsValid().toString();
  }

  String prettyPrint() {
    String print = '=== isValid? ==> ${checkIsValid()} \n';

//    print += 'Name => $name \n';
    print += 'Flour amount => $flourAmount \n';

    ingredients.forEach((Ingredient ingredient) {
      print +=
          '   -- Ingredient: ${ingredient.name} [ ${printPercent(ingredient.percent)} => ${ingredient.value}g ] \n';
      if (ingredient.subIngredients != null) {
        List<Ingredient> subIngredients = ingredient.subIngredients;
        subIngredients.forEach((Ingredient subIngredient) {
          print += '   |     SubIngredient: ${subIngredient.name} [${printPercent(subIngredient.percent)} => ${subIngredient.value.toInt()}g ] \n';
        });
      }
    });

    return print += '==============================';
  }
}
