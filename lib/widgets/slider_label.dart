import 'package:flutter/material.dart';

class SliderLabel extends StatelessWidget {
  const SliderLabel({@required this.label, this.focus, this.invertColors});

  final String label;
  final bool focus;
  final bool invertColors;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).accentTextTheme.title;

    style.copyWith(color: invertColors ? Colors.black : Colors.white);

    return Text(
      label,
      style: style.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
