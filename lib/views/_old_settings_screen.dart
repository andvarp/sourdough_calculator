import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/i18n/sample_change_locale.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:sourdough_calculator/widgets/slider_with_label.dart';

class OldSettingsView extends StatefulWidget {
  @override
  _OldSettingsViewState createState() => _OldSettingsViewState();
}

class _OldSettingsViewState extends State<OldSettingsView> {
  RecipeProvider _provider;
  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<RecipeProvider>(context);

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.teal,
              ),
              child: Column(
                children: buildIngredients(
                  provider: _provider,
                  ingredients: _provider.currentRecipe.ingredients,
                  parent: null,
                ),
              ),
            ),
            Card(
              child: Text(_provider.currentRecipe.prettyPrint()),
            ),
            SampleChangeLocale(),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  Function onSliderChanged(
      RecipeProvider _provider, Ingredient ingredient, Ingredient parent) {
    return (double value) {
      double newValue;
      switch (ingredient.type) {
        case IngredientType.whiteFlour:
        case IngredientType.wholeFlour:
        case IngredientType.fat:
        case IngredientType.other:
        case IngredientType.sourdough:
        case IngredientType.sugar:
        case IngredientType.flour:
        case IngredientType.water:
        case IngredientType.salt:
          newValue = (value).roundToDouble();
          break;
        default:
          break;
      }

      _provider.changePercent(ingredient, setPercent(newValue.toInt()), parent);
    };
  }

  List<Widget> buildIngredients(
      {RecipeProvider provider,
      List<Ingredient> ingredients,
      Ingredient parent}) {
    List<Widget> widgets = [];
    ingredients.forEach((ingredient) {
      if (ingredient.valueBounds != null) {
        widgets.add(buildIngredient(provider, ingredient, parent));
      }
      if (ingredient.subIngredients != null) {
        widgets.addAll(buildIngredients(
            provider: provider,
            ingredients: ingredient.subIngredients,
            parent: ingredient));
      }
    });
    return widgets;
  }

  Widget buildIngredient(
      RecipeProvider _provider, Ingredient ingredient, Ingredient parent) {
    return SliderWithLabel(
      invertColors: true,
      label: '${ingredient.name}: ${printAmount(ingredient.value.toInt())}',
      value: ingredient.percent * 100,
      onSliderChanged: onSliderChanged(_provider, ingredient, parent),
      min: ingredient.valueBounds[0],
      max: ingredient.valueBounds[1],
      startLabel: printPercent(setPercent(ingredient.valueBounds[0].toInt())),
      endLabel: printPercent(setPercent(ingredient.valueBounds[1].toInt())),
      mapValueToString: (double value) =>
          printPercent(setPercent(value.toInt())),
    );
  }
}
