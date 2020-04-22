import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/sourdough.dart';
import 'package:sourdough_calculator/constants.dart';
import 'package:sourdough_calculator/data/sourdough_provider.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:sourdough_calculator/widgets/pie_chart_card.dart';
import 'package:sourdough_calculator/widgets/slider_with_label.dart';

class ResultsView extends StatefulWidget {
  @override
  _ResultsViewState createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  Function onSliderChanged(SourdoughProvider _provider) {
    return (double value) {
      double newValue = (value / 100).roundToDouble() * 100;
      _provider.changeFlourAmount(newValue.toInt());
    };
  }

  List<PieDataEntry> getPieData(Sourdough _sourdough) {
    List<PieDataEntry> data = <PieDataEntry>[
      PieDataEntry(
        color: Color(0xfff8b250),
        sectionText: 'Flour',
        text: printAmount(_sourdough.dryFlourTotal),
        value: _sourdough.dryFlourTotal.toDouble(),
      ),
      PieDataEntry(
        color: Color(0xff0293ee),
        sectionText: 'Water',
        text: printAmount(_sourdough.waterToAdd),
        value: _sourdough.waterToAdd.toDouble(),
      ),
      PieDataEntry(
        color: Color(0xff845bef),
        sectionText: 'Sourdough',
        text: printAmount(_sourdough.sourdoughTotal),
        value: _sourdough.sourdoughTotal.toDouble(),
      ),
      PieDataEntry(
        color: Color(0xff13d38e),
        sectionText: 'Salt',
        text: printAmount(_sourdough.saltToAdd),
        value: _sourdough.sourdoughTotal.toDouble() / 2,
      ),
    ];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final SourdoughProvider _provider = Provider.of<SourdoughProvider>(context);
    final int _flourAmount = _provider.sourdough.flourAmount;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
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
          PieChartCard(data: getPieData(_provider.sourdough)),
        ],
      ),
    );
  }
}
