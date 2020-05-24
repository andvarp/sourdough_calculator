import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/data/ingredient.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:sourdough_calculator/widgets/pie_chart_card.dart';
import 'package:sourdough_calculator/widgets/slider_with_label.dart';

class RecipeEditView extends StatefulWidget {
  @override
  _RecipeEditViewState createState() => _RecipeEditViewState();
}

class _RecipeEditViewState extends State<RecipeEditView> {
  List<PieDataEntry> getPieData(Recipe _recipe) {
    List<Color> colors = [
      Color(0xff845bef),
      Color(0xfff8b250),
      Color(0xff0293ee),
      Color(0xff13d38e),
      Color(0xff13d38e),
      Color(0xff13d38e),
      Color(0xff13d38e),
      Color(0xff13d38e),
    ];

    List<PieDataEntry> data = [];

    _recipe.ingredients.forEach((ingredient) {
      data.add(PieDataEntry(
        color: colors[data.length],
        sectionText: ingredient.name,
        text: printAmount(ingredient.value.toInt()),
        value: ingredient.value,
      ));
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
//    I18n i18n = I18n.of(context);
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    Recipe recipe = recipeProvider.currentRecipe;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: width * 0.5,
                  child: Text(
                    recipe.name,
                    style: TextStyle(
                        color: Colors.black87.withOpacity(0.8),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ExpandableTheme(
              data: const ExpandableThemeData(
                iconColor: Colors.blue,
                useInkWell: true,
              ),
              child: Column(
                children: <Widget>[
                  Card1(),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            PieChartCard(data: getPieData(recipeProvider.currentRecipe)),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              onPressed: () {
                recipeProvider.safeToLocalStorage();
              },
              child: const Text('Save to the phone',
                  style: TextStyle(fontSize: 20)),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              child: Text(
                recipe.prettyPrint(),
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Card1 extends StatelessWidget {
  Function onFlourAmountSliderChanged(RecipeProvider _provider) {
    return (double value) {
      double newValue = (value / 100).roundToDouble() * 100;
      _provider.changeFlourAmount(newValue.toInt());
    };
  }

  Function onInternalSliderChanged(
      RecipeProvider _provider, Ingredient ingredient, Ingredient parent) {
    return (double value) {
      double newValue = (value).roundToDouble();
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
      label: '${ingredient.name}: ${printAmount(ingredient.value.toInt())}',
      value: ingredient.percent * 100,
      onSliderChanged: onInternalSliderChanged(_provider, ingredient, parent),
      min: ingredient.valueBounds[0],
      max: ingredient.valueBounds[1],
      startLabel: printPercent(setPercent(ingredient.valueBounds[0].toInt())),
      endLabel: printPercent(setPercent(ingredient.valueBounds[1].toInt())),
      mapValueToString: (double value) =>
          printPercent(setPercent(value.toInt())),
    );
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    Recipe recipe = recipeProvider.currentRecipe;
    return ExpandableNotifier(
        child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            child: SliderWithLabel(
              label: 'Select the amount of flour:',
              value: recipe.flourAmount.toDouble(),
              onSliderChanged: onFlourAmountSliderChanged(recipeProvider),
              min: kSliderMin.toDouble(),
              max: kSliderMax.toDouble(),
              startLabel: printKgAmount(kSliderMin.toInt()),
              endLabel: printKgAmount(kSliderMax.toInt()),
              mapValueToString: (double value) => printKgAmount(value.toInt()),
            ),
          ),
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Ingredients",
                    style: Theme.of(context).textTheme.body2),
              ),
              expanded: Container(
                child: Column(
                  children: buildIngredients(
                    provider: recipeProvider,
                    ingredients: recipeProvider.currentRecipe.ingredients,
                    parent: null,
                  ),
                ),
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
