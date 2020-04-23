import 'package:flutter/foundation.dart';

enum IngredientType {
  flour,
  whiteFlour,
  wholeFlour,
  water,
  salt,
  fat,
  other,
  sourdough,
  sugar,
}

//enum subIngredientType {
//  whiteFlour,
//  wholeFlour,
//}

abstract class IngredientAbstract {
  String name;
  double percent;
  double value;
  IngredientType type;
  Map<IngredientType, Ingredient> subIngredients;
  List<double> valueBounds;
  String toString();
}

class Ingredient extends IngredientAbstract {
  Ingredient({
    String name = '',
    double percent = 0.0,
    IngredientType type = IngredientType.other,
    Map<IngredientType, Ingredient> subIngredients =
        const <IngredientType, Ingredient>{},
    List<double> valueBounds = const <double>[],
  }) {
    this.name = name;
    this.percent = percent;
    this.type = type;
    this.valueBounds = valueBounds;

    if (subIngredients != null && subIngredients.keys.length > 0) {
      this.subIngredients = subIngredients;
    }
  }

  static Ingredient fromIngredient(Ingredient ingredient) {
    return Ingredient(
      name: ingredient.name,
      percent: ingredient.percent,
      type: ingredient.type,
      subIngredients: ingredient.subIngredients,
      valueBounds: ingredient.valueBounds,
    );
  }

  @override
  String toString() {
    String subIngredientsRaw = '';
    if (subIngredients != null) {
      subIngredients.forEach((k, sI) => subIngredientsRaw += sI.toString());
    }
    return '{ name: $name, percent: $percent, value: $value, '
        'type: ${describeEnum(type)}, subIngredients: ${subIngredients?.length}, '
        '${(subIngredients?.length ?? 0) > 0 ? 'subIngredientsRaw: [$subIngredientsRaw}]' : ''} }';
  }
}
