import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:sourdough_calculator/widgets/slider_label.dart';

class SliderWithLabel extends StatefulWidget {
  SliderWithLabel({
    this.label = '',
    this.value = 0,
    this.min = 0,
    this.max = 100,
    this.startLabel = '',
    this.endLabel = '',
    this.invertColors = false,
    this.onSliderChanged,
    this.mapValueToString,
  });

  final Function onSliderChanged;
  final Function mapValueToString;
  final double value;
  final double min;
  final double max;
  final String startLabel;
  final String endLabel;
  final String label;
  final bool invertColors;

  @override
  _SliderWithLabelState createState() => _SliderWithLabelState();
}

class _SliderWithLabelState extends State<SliderWithLabel> {
  bool isDragging = false;

  void setIsDragging(bool newValue) {
    setState(() {
      isDragging = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color thumbColor = widget.invertColors ? Colors.orangeAccent : Colors.white;
    const horizontalPadding = 10.0;

    if (isDragging) {
      if (widget.invertColors) {
        thumbColor = Colors.orangeAccent;
      } else {
        thumbColor = Colors.white;
      }
    } else {
      if (widget.invertColors) {
        thumbColor = Colors.orangeAccent;
      } else {
        thumbColor = Colors.white;
      }
    }
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.title.copyWith(
                      color: widget.invertColors
                          ? Colors.white
                          : Theme.of(context).textTheme.title.color),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 20.0),
                  child: FluidSlider(
                    value: widget.value,
                    min: widget.min,
                    max: widget.max,
                    start: SliderLabel(
                        label: widget.startLabel,
                        focus: isDragging,
                        invertColors: widget.invertColors),
                    end: SliderLabel(
                      label: widget.endLabel,
                      focus: isDragging,
                      invertColors: widget.invertColors,
                    ),
                    valueTextStyle: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 15.0,
                          color:
                              widget.invertColors ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                    mapValueToString: widget.mapValueToString,
                    onChanged: widget.onSliderChanged,
                    sliderColor:
                        widget.invertColors ? Colors.white : Colors.orangeAccent,
                    onChangeEnd: (_) => setIsDragging(false),
                    onChangeStart: (_) => setIsDragging(true),
                    thumbColor: thumbColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          indent: horizontalPadding,
          endIndent: horizontalPadding,
        ),
      ],
    );
  }
}
