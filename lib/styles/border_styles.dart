import 'package:flutter/material.dart';

class BorderStyles {
  static InputDecorationTheme inputDecorationTheme(BuildContext context) =>
      Theme.of(context).inputDecorationTheme;

  static Color enabledBorderColor = Color.fromARGB(255, 120, 120, 120);

  static final double bigBorderRadiusValue = 10;
  static final double defaultBorderRadiusValue = 10;
  static final double smallBorderRadiusValue = 5;

  static BorderRadius bigBorderRadius =
      BorderRadius.circular(bigBorderRadiusValue);
  static BorderRadius defaultBorderRadius =
      BorderRadius.circular(defaultBorderRadiusValue);
  static BorderRadius smallBorderRadius =
      BorderRadius.circular(smallBorderRadiusValue);
}
