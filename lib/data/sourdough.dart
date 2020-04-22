import 'package:sourdough_calculator/utils.dart';

class Sourdough {
  Sourdough({
    int flourAmount,
    double flourPercent,
    double hydrationPercent,
    double saltPercent,
    double sourdoughPercent,
    double waterInSourdoughPercent,
    double whiteFlourPercent,
    double wholemealFlourPercent,
  }) {
    this.flourAmount = flourAmount;
    this.flourPercent = flourPercent;
    this.hydrationPercent = hydrationPercent;
    this.saltPercent = saltPercent;
    this.sourdoughPercent = sourdoughPercent;
    this.waterInSourdoughPercent = waterInSourdoughPercent;
    this.whiteFlourPercent = whiteFlourPercent;
    this.wholemealFlourPercent = wholemealFlourPercent;

    calculateValues();
  }

  static fromSourdough(Sourdough sourdough) {
    return Sourdough(
      flourAmount: sourdough.flourAmount,
      flourPercent: sourdough.flourPercent,
      hydrationPercent: sourdough.hydrationPercent,
      saltPercent: sourdough.saltPercent,
      sourdoughPercent: sourdough.sourdoughPercent,
      waterInSourdoughPercent: sourdough.waterInSourdoughPercent,
      whiteFlourPercent: sourdough.whiteFlourPercent,
      wholemealFlourPercent: sourdough.wholemealFlourPercent,
    );
  }

  Sourdough copyWith({
    int flourAmount,
    double flourPercent,
    double hydrationPercent,
    double saltPercent,
    double sourdoughPercent,
    double waterInSourdoughPercent,
    double whiteFlourPercent,
    double wholemealFlourPercent,
  }) {
    return Sourdough(
      flourAmount: flourAmount ?? this.flourAmount,
      flourPercent: flourPercent ?? this.flourPercent,
      hydrationPercent: hydrationPercent ?? this.hydrationPercent,
      saltPercent: saltPercent ?? this.saltPercent,
      sourdoughPercent: sourdoughPercent ?? this.sourdoughPercent,
      waterInSourdoughPercent:
          waterInSourdoughPercent ?? this.waterInSourdoughPercent,
      whiteFlourPercent: whiteFlourPercent ?? this.whiteFlourPercent,
      wholemealFlourPercent:
          wholemealFlourPercent ?? this.wholemealFlourPercent,
    );
  }

  bool isValid;

  // -- config fields --
  int flourAmount;
  double flourPercent;
  double hydrationPercent;
  double saltPercent;
  double sourdoughPercent;
  double waterInSourdoughPercent;
  double whiteFlourPercent;
  double wholemealFlourPercent;

  // -- calculated fields --
  // sourdough fields
  int sourdoughTotal;
  int waterInSourdough;
  int flourInSourdough;

  // flour fields
  int dryFlourTotal;
  int dryWhiteFlour;
  int dryWholemealFlour;

  // water fields
  int waterToAdd;

  // salt field
  int saltToAdd;

  void setFlourAmount(int amount) {
    flourAmount = amount;
    calculateValues();
  }

  void calculateValues() {
    _setSourdoughData();
    _setFlourData();
    _setWaterData();
    _setSaltData();

    checkIsValid();
  }

  bool checkIsValid() {
    bool waterValid =
        (waterToAdd + waterInSourdough) == (flourAmount * hydrationPercent);
    bool flourValid =
        (flourInSourdough + dryWhiteFlour + dryWholemealFlour) == flourAmount;
    isValid = waterValid && flourValid;
    return isValid;
  }

  _setSourdoughData() {
    sourdoughTotal = (flourAmount * sourdoughPercent).toInt();
    waterInSourdough = roundValue(sourdoughTotal * waterInSourdoughPercent);
    flourInSourdough = sourdoughTotal - waterInSourdough;
  }

  _setFlourData() {
    dryFlourTotal = flourAmount - flourInSourdough;
    dryWhiteFlour = roundValue(dryFlourTotal * whiteFlourPercent);
    dryWholemealFlour = dryFlourTotal - dryWhiteFlour;
  }

  _setWaterData() {
    waterToAdd = (flourAmount * hydrationPercent - waterInSourdough).toInt();
  }

  _setSaltData() {
    saltToAdd = (flourAmount * saltPercent).toInt();
  }

  String log({bool verbose = false}) {
    String log = '''-- Config --
flourAmount => $flourAmount
flourPercent => ${printPercent(flourPercent)}
hydrationPercent => ${printPercent(hydrationPercent)}
saltPercent => ${printPercent(saltPercent)}
sourdoughPercent => ${printPercent(sourdoughPercent)}
waterInSourdoughPercent => ${printPercent(waterInSourdoughPercent)}
whiteFlourPercent => ${printPercent(whiteFlourPercent)}
wholemealFlourPercent => ${printPercent(wholemealFlourPercent)}

-- Sourdough --
sourdoughTotal => ${printAmount(sourdoughTotal)}
${verbose ? 'waterInSourdough => ${printAmount(waterInSourdough)}' : ''}
${verbose ? 'flourInSourdough => ${printAmount(flourInSourdough)}' : ''}

-- Flour --
dryFlourTotal => ${printAmount(dryFlourTotal)}
dryWhiteFlour => ${printAmount(dryWhiteFlour)}
dryWholemealFlour => ${printAmount(dryWholemealFlour)}

-- Water --
waterToAdd => ${printAmount(waterToAdd)}

-- Salt --
saltToAdd => ${printAmount(saltToAdd)}

${verbose ? '''-- CHECK --
isValid? => $isValid''' : ''}''';
    return log;
  }
}

Sourdough sourdough60 = Sourdough(
  flourAmount: 1000,
  flourPercent: setPercent(100),
  hydrationPercent: setPercent(60),
  saltPercent: setPercent(2),
  sourdoughPercent: setPercent(30),
  waterInSourdoughPercent: setPercent(33),
  whiteFlourPercent: setPercent(80),
  wholemealFlourPercent: setPercent(20),
);
