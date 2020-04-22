import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartCard extends StatefulWidget {
  PieChartCard({this.data});

  final List<PieDataEntry> data;

  @override
  _PieChartCardState createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (pieTouchResponse) {
                      if (!(pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd)) {
                        setState(() {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        });
                      }
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 70,
                  sections: showingSections(),
                )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getIndicators(),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getIndicators() {
    List<Widget> indicators = [];

    for (var i = 0; i < widget.data.length; i++) {
      PieDataEntry entry = widget.data[i];
      indicators.add(
        Indicator(
          color: entry.color,
          text: entry.sectionText,
          size: touchedIndex == i ? 18 : 16,
          textColor: touchedIndex == i ? Colors.black : Colors.grey,
          onTap: () {
            setState(() {
              touchedIndex = i;
            });
          },
        ),
      );
    }

    return indicators;
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> sections = [];

    for (var i = 0; i < widget.data.length; i++) {
      PieDataEntry entry = widget.data[i];
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 70 : 50;

      sections.add(
        PieChartSectionData(
          color: entry.color,
          value: entry.value,
          title: entry.text,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }
}

class PieDataEntry {
  PieDataEntry({this.color, this.text, this.sectionText, this.value});
  final Color color;
  final String text;
  final String sectionText;
  final double value;
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
    this.color,
    this.text,
    this.size = 16,
    this.textColor = Colors.grey,
    this.onTap,
  }) : super(key: key);

  final Color color;
  final String text;
  final double size;
  final Color textColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
