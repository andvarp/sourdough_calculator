String printPercent(double number) => '${(number * 100).toInt()}%';
String printAmount(int number) => '${number}g';
String printKgAmount(int number) => '${(number / 1000)}kg';
double setPercent(int number) => number / 100;
int roundValue(double number) => ((number / 10).round() * 10);
double roundValueToDouble(double number) =>
    ((number / 10).roundToDouble() * 10);
