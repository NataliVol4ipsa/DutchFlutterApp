// ignore_for_file: prefer_const_constructors
import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String value;
  final bool isRequired;
  final double scale;

  const InputLabel(
    this.value, {
    this.isRequired = false,
    this.scale = 1.1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        value,
        textScaler: TextScaler.linear(scale),
        style: TextStyle(
            color: BaseStyles.getColorScheme(context).onSurface.withAlpha(200),
            fontStyle: FontStyle.italic),
      ),
      if (isRequired)
        Text(
          " *",
          style: TextStyle(
            color: Colors.red,
          ),
          textScaler: TextScaler.linear(scale),
        ),
      Text(
        ":",
        textScaler: TextScaler.linear(scale),
      ),
    ]);
  }
}
