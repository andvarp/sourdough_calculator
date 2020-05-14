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
  List<double> valueBounds;
  List<Ingredient> subIngredients;

  String toString();
}

class Ingredient extends IngredientAbstract{

  Ingredient({
    String name = '',
    double percent = 0.0,
    IngredientType type = IngredientType.other,
    List<double> valueBounds = const <double>[],
    List<Ingredient> subIngredients = const <Ingredient>[],
  }) {
    this.name = name;
    this.percent = percent;
    this.type = type;
    this.valueBounds = valueBounds;

    if (subIngredients != null && subIngredients.length > 0) {
      this.subIngredients = subIngredients;
    }
  }

  static Ingredient fromIngredient(Ingredient ingredient) {
    return Ingredient(
      name: ingredient.name,
      percent: ingredient.percent,
      type: ingredient.type,
      valueBounds: ingredient.valueBounds,
      subIngredients: ingredient.subIngredients,
    );
  }


  @override
  String toString() {
    return this.toJson().toString();
  }

  Ingredient.fromJson(Map<String, dynamic> json) {
    assert(json['name'] != null);
    name = json['name'];

    assert(json['percent'] != null);
    percent = json['percent'];

    assert(json['type'] != null);
    type = IngredientType.values.firstWhere((e) => describeEnum(e.toString()) == json['type']);

    value = json['value'] ?? 0.0;

    if (json['valueBounds'] != null) {
      valueBounds = json['valueBounds'].cast<double>();
    }

    if (json['subIngredients'] != null) {
      subIngredients = new List<Ingredient>();
      json['subIngredients'].forEach((v) {
        subIngredients.add(new Ingredient.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['percent'] = this.percent;
    data['value'] = this.value;
    data['type'] = describeEnum(this.type);
    data['valueBounds'] = this.valueBounds;
    if (this.subIngredients != null) {
      data['subIngredients'] = this.subIngredients.map((v) => v.toJson()).toList();
    }
    return data;
  }
}