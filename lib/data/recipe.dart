import 'dart:convert' as convert;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/logger.dart';
import 'package:sourdough_calculator/utils.dart';

abstract class RecipeAbstract {
  String name;
  int flourAmount;
  List<Ingredient> ingredients;
  bool isPrivate;
  String uid;
  Timestamp createdAt;
  Timestamp modifiedAt;
  String toString();
}

class Recipe extends RecipeAbstract {
  Recipe({
    String name = "",
    int flourAmount = kInitialFlourAMount,
    List<Ingredient> ingredients = const <Ingredient>[],
    bool isPrivate = true,
    String uid = "",
    Timestamp createdAt,
    Timestamp modifiedAt,
  }) {
    this.name = name;
    this.flourAmount = flourAmount;
    this.ingredients = ingredients;
    this.isPrivate = isPrivate;
    this.uid = uid;
    this.createdAt = createdAt == null ? Timestamp.now() : createdAt;
    this.modifiedAt = modifiedAt;

    computeValues();
  }

  Map<IngredientType, Ingredient> getIngredientsMap(
      List<Ingredient> ingredients) {
    Map<IngredientType, Ingredient> map = new Map<IngredientType, Ingredient>();
    if (ingredients != null) {
      ingredients.forEach((ingredient) {
        map[ingredient.type] = ingredient;
      });
    }
    return map;
  }

  void computeValues() {
    Map<IngredientType, Ingredient> ingredientsMap =
        getIngredientsMap(ingredients);
    Map<IngredientType, Ingredient> sourdoughSubIngredientsMap =
        getIngredientsMap(
            ingredientsMap[IngredientType.sourdough].subIngredients);

    ingredientsMap.forEach((type, ingredient) {
      switch (type) {
        case IngredientType.sourdough:
          ingredient.value = flourAmount * ingredient.percent;
          break;
        case IngredientType.flour:
          double sourdoughFlour =
              sourdoughSubIngredientsMap[IngredientType.flour].value;
          ingredient.value =
              (flourAmount * ingredient.percent) - sourdoughFlour;
          break;
        case IngredientType.water:
          double sourdoughWater =
              sourdoughSubIngredientsMap[IngredientType.water].value;
          ingredient.value =
              (flourAmount * ingredient.percent) - sourdoughWater;
          break;
        case IngredientType.salt:
        default:
          ingredient.value = flourAmount * ingredient.percent;
          break;
      }

      ingredient.subIngredients = computeSubIngredients(ingredient.value,
          getIngredientsMap(ingredientsMap[type].subIngredients));
    });

    ingredients = ingredientsMap.values.toList();
  }

  List<Ingredient> computeSubIngredients(double mainIngredientValue,
      Map<IngredientType, Ingredient> subIngredientsMap) {
    if (subIngredientsMap != null) {
      subIngredientsMap.forEach((subType, subIngredient) {
        subIngredient.value =
            roundValueToDouble(mainIngredientValue * subIngredient.percent);
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
      Map<IngredientType, Ingredient> subIngredientsMap =
          getIngredientsMap(parent.subIngredients);
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

  Map<String, dynamic> checkIsValid() {
    double allPercents = 0;
    double allValues = 0;
    bool isValid;
    getIngredientsMap(ingredients).forEach((type, ingredient) {
      if (type != IngredientType.sourdough) {
        allPercents += ingredient.percent;
      }
      allValues += ingredient.value;
    });
    double calculatedValues = (allPercents * flourAmount).roundToDouble();
    isValid = calculatedValues == allValues;
    return <String, dynamic>{
      "isValid": isValid,
      "allValues": allValues,
      "calculatedValues": calculatedValues,
    };
  }

  Recipe.fromJson(Map<String, dynamic> json) {
    try {
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

      assert(json['isPrivate'] != null);
      isPrivate = json['isPrivate'];

      assert(json['uid'] != null);
      uid = json['uid'];

//      assert(json['createdAt'] != null);
      logger.i('$name: ${json['createdAt']}');
//      logger.i(convert.json.encode(json));
//      createdAt = Timestamp.fromDate(DateTime.utc(json['createdAt']) );
      createdAt = Timestamp.fromDate(
          DateTime.parse(json['createdAt'].toDate().toIso8601String()));

      modifiedAt = json['modifiedAt'];
    } catch (e, s) {
      String msg =
          'Recipe fromJson failed! { name: $name, uid: $uid, rawJson:, e: $e, s: $s, }';
      logger.e(msg);
      Crashlytics.instance.recordError(e, s, context: msg);
    }

    computeValues();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['name'] = this.name;
      data['flourAmount'] = this.flourAmount;
      if (this.ingredients != null) {
        data['ingredients'] = this.ingredients.map((v) => v.toJson()).toList();
      }

      data['isPrivate'] = this.isPrivate;
      data['uid'] = this.uid;

      data['createdAt'] = this.createdAt.toDate().toIso8601String();

      data['modifiedAt'] = this.modifiedAt;
    } catch (e, s) {
      String msg =
          'Recipe toJson failed! { name: $name, uid: $uid, createdAt: $createdAt , e: $e, s: $s, }';
      logger.e(msg);
      Crashlytics.instance.recordError(e, s, context: msg);
    }

    return data;
  }

  String toString() {
    return toJson().toString() + '\nIs Valid >> ' + checkIsValid().toString();
  }

  String prettyPrint() {
    String print = '=== isValid? ==> ${checkIsValid().toString()} \n';

    print += 'Name => $name \n';
    print += 'Flour amount => $flourAmount \n';

    ingredients.forEach((Ingredient ingredient) {
      print +=
          '   -- Ingredient: ${ingredient.name} [ ${printPercent(ingredient.percent)} => ${ingredient.value}g ] \n';
      if (ingredient.subIngredients != null) {
        List<Ingredient> subIngredients = ingredient.subIngredients;
        subIngredients.forEach((Ingredient subIngredient) {
          print +=
              '   |      subIngr:      ${subIngredient.name} [${printPercent(subIngredient.percent)} => ${subIngredient.value.toInt()}g ] \n';
        });
      }
    });

    print += '\n';
    print += 'Private => $isPrivate \n';
    print += 'UID => ${uid.length == 0 ? '<empty>' : uid} \n';
    print += 'Created => ${createdAt?.toDate()} \n';
    print += 'Modified => $modifiedAt \n';

    return print += '==============================\n\n';
  }
}
