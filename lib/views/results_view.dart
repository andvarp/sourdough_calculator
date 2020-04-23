import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/recipe.dart';
import 'package:sourdough_calculator/data/recipe_provider.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/i18n/app_localizations.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:sourdough_calculator/widgets/pie_chart_card.dart';
import 'package:sourdough_calculator/widgets/slider_with_label.dart';

class ResultsView extends StatefulWidget {
  @override
  _ResultsViewState createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  Function onSliderChanged(RecipeProvider _provider) {
    return (double value) {
      double newValue = (value / 100).roundToDouble() * 100;
      _provider.changeFlourAmount(newValue.toInt());
    };
  }

  List<PieDataEntry> getPieData(Recipe _recipe) {
    List<Color> colors = [
      Color(0xfff8b250),
      Color(0xff0293ee),
      Color(0xff845bef),
      Color(0xff13d38e),
    ];

    List<PieDataEntry> data = [];

    _recipe.ingredients.forEach((type, ingredient) {
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
    final RecipeProvider _provider = Provider.of<RecipeProvider>(context);
    final int _flourAmount = _provider.recipe.flourAmount;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: <Widget>[
          Text(AppLocalizations.of(context).translate('title')),
          SliderWithLabel(
            label: 'Select the amount of flour:',
            value: _flourAmount.toDouble(),
            onSliderChanged: onSliderChanged(_provider),
            min: kSliderMin.toDouble(),
            max: kSliderMax.toDouble(),
            startLabel: printKgAmount(kSliderMin.toInt()),
            endLabel: printKgAmount(kSliderMax.toInt()),
            mapValueToString: (double value) => printKgAmount(value.toInt()),
          ),
          PieChartCard(data: getPieData(_provider.recipe)),
        ],
      ),
    );
  }
}
