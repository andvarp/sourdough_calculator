import 'package:flutter/material.dart';
import 'package:sourdough_calculator/data/sourdough.dart';
import 'package:sourdough_calculator/data/sourdough_enum.dart';

class SourdoughProvider extends ChangeNotifier {
  Sourdough sourdough = sourdough60;

  void changeFlourAmount(int amount) {
    sourdough = sourdough.copyWith(flourAmount: amount);
    notifyListeners();
  }

  void changePercent(SourdoughEnum sourdoughEnum, double percent) {
    sourdough = sourdough.copyWith();
    switch (sourdoughEnum) {
      case SourdoughEnum.flourPercent:
        sourdough = sourdough.copyWith(flourPercent: percent);
        break;
      case SourdoughEnum.hydrationPercent:
        sourdough = sourdough.copyWith(hydrationPercent: percent);
        break;
      case SourdoughEnum.saltPercent:
        sourdough = sourdough.copyWith(saltPercent: percent);
        break;
      case SourdoughEnum.sourdoughPercent:
        sourdough = sourdough.copyWith(sourdoughPercent: percent);
        break;
      case SourdoughEnum.waterInSourdoughPercent:
        sourdough = sourdough.copyWith(waterInSourdoughPercent: percent);
        break;
      case SourdoughEnum.whiteFlourPercent:
        sourdough = sourdough.copyWith(whiteFlourPercent: percent);
        break;
      case SourdoughEnum.wholemealFlourPercent:
        sourdough = sourdough.copyWith(wholemealFlourPercent: percent);
        break;
      default:
        break;
    }

    notifyListeners();
  }
}
