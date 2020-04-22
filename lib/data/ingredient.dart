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

abstract class IngredientAbstract {
  String name;
  double percent;
  double value;
  IngredientType type;
  Map<IngredientType, Ingredient> subIngredients;
  String toString();
}

class Ingredient extends IngredientAbstract {
  Ingredient({
    String name = '',
    double percent = 0.0,
    IngredientType type = IngredientType.other,
    Map<IngredientType, Ingredient> subIngredients =
        const <IngredientType, Ingredient>{},
  }) {
    this.name = name;
    this.percent = percent;
    this.type = type;

    if (subIngredients.keys.length > 0) {
      this.subIngredients = subIngredients;
    }
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
