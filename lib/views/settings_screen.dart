import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sourdough_calculator/data/sourdough_enum.dart';
import 'package:sourdough_calculator/data/sourdough_provider.dart';
import 'package:sourdough_calculator/utils.dart';
import 'package:sourdough_calculator/widgets/slider_with_label.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final SourdoughProvider _provider = Provider.of<SourdoughProvider>(context);

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
                children: <Widget>[
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'Hydratation: ${printPercent(_provider.sourdough.hydrationPercent)}',
                    value: _provider.sourdough.hydrationPercent * 100,
                    onSliderChanged: onSliderChanged(
                        _provider, SourdoughEnum.hydrationPercent),
                    min: 50,
                    max: 120,
                    startLabel: printPercent(.5),
                    endLabel: printPercent(1.2),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
//                  todo make other card for sourdough
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'Sourdough: ${printPercent(_provider.sourdough.sourdoughPercent)}',
                    value: _provider.sourdough.sourdoughPercent * 100,
                    onSliderChanged: onSliderChanged(
                        _provider, SourdoughEnum.sourdoughPercent),
                    min: 0,
                    max: 60,
                    startLabel: printPercent(0),
                    endLabel: printPercent(0.6),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'Water inside the sourdough (hard sourdough recommended): ${printPercent(_provider.sourdough.waterInSourdoughPercent)}',
                    value: _provider.sourdough.waterInSourdoughPercent * 100,
                    onSliderChanged: onSliderChanged(
                        _provider, SourdoughEnum.waterInSourdoughPercent),
                    min: 0,
                    max: 100,
                    startLabel: printPercent(0),
                    endLabel: printPercent(1),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'Salt: ${printPercent(_provider.sourdough.saltPercent)}',
                    value: _provider.sourdough.saltPercent * 100,
                    onSliderChanged:
                        onSliderChanged(_provider, SourdoughEnum.saltPercent),
                    min: 0,
                    max: 10,
                    startLabel: printPercent(0),
                    endLabel: printPercent(0.1),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'White flour percent: ${printPercent(_provider.sourdough.whiteFlourPercent)}',
                    value: _provider.sourdough.whiteFlourPercent * 100,
                    onSliderChanged: onSliderChanged(
                        _provider, SourdoughEnum.whiteFlourPercent),
                    min: 0,
                    max: 100,
                    startLabel: printPercent(0),
                    endLabel: printPercent(1),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
                  // todo make in data layer this values to be dependant
                  SliderWithLabel(
                    invertColors: true,
                    label:
                        'Wholemeal flour percent: ${printPercent(_provider.sourdough.wholemealFlourPercent)}',
                    value: _provider.sourdough.wholemealFlourPercent * 100,
                    onSliderChanged: onSliderChanged(
                        _provider, SourdoughEnum.wholemealFlourPercent),
                    min: 0,
                    max: 100,
                    startLabel: printPercent(0),
                    endLabel: printPercent(1),
                    mapValueToString: (double value) =>
                        printPercent(setPercent(value.toInt())),
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Function onSliderChanged(
      SourdoughProvider _provider, SourdoughEnum sourdoughEnum) {
    return (double value) {
      double newValue;
      switch (sourdoughEnum) {
        case SourdoughEnum.hydrationPercent:
        case SourdoughEnum.sourdoughPercent:
        case SourdoughEnum.waterInSourdoughPercent:
        case SourdoughEnum.whiteFlourPercent:
        case SourdoughEnum.wholemealFlourPercent:
          newValue = (value / 5).roundToDouble() * 5;
          break;
        case SourdoughEnum.saltPercent:
          newValue = (value).roundToDouble();
          break;
        default:
          break;
      }
      _provider.changePercent(sourdoughEnum, setPercent(newValue.toInt()));
    };
  }
}
