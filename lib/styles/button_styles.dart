import 'dart:math';

import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyles {
  static final double minimalButtonHeight = 48;
  static double minimalButtonVerticalPadding(double fontSize) =>
      (minimalButtonHeight - fontSize) / 2;

  static final double largeButtonFontSize = 20;
  static final double mediumButtonFontSize = 16;

  static ButtonStyle _baseButtonStyle(double fontSize,
      {double? horizontalPadding,
      double? verticalPadding,
      FontWeight? fontWeight = FontWeight.normal}) {
    //recommended button height per font is 8 + fontSize * 2
    horizontalPadding ??= max(minimalButtonVerticalPadding(fontSize),
        ((8 + fontSize * 2) - fontSize) / 2);
    verticalPadding ??= max(minimalButtonVerticalPadding(fontSize),
        ((8 + fontSize * 2) - fontSize) / 2);

    return ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderStyles.defaultBorderRadius),
        ),
        textStyle: WidgetStateProperty.all(TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        )));
  }

  static Color primaryButtonColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).primaryContainer;
  static Color primaryButtonColorText(BuildContext context) =>
      BaseStyles.getColorScheme(context).onPrimaryContainer;

  static Color secondaryButtonColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).secondaryContainer;
  static Color secondaryButtonColorText(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSecondaryContainer;

  static Color tertiaryButtonBorderColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).outline;
  static Color tertiaryButtonColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHigh;
  static Color tertiaryButtonColorText(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static ButtonStyle largePrimaryButtonStyle(BuildContext context,
      {FontWeight? fontWeight}) {
    return _baseButtonStyle(largeButtonFontSize, fontWeight: fontWeight)
        .copyWith(
      backgroundColor: createButtonStyleColor(primaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(primaryButtonColorText(context)),
    );
  }

  static ButtonStyle largeWidePrimaryButtonStyle(BuildContext context) {
    return _baseButtonStyle(largeButtonFontSize,
            verticalPadding: 20, fontWeight: FontWeight.bold)
        .copyWith(
      backgroundColor: createButtonStyleColor(primaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(primaryButtonColorText(context)),
    );
  }

  static ButtonStyle mediumPrimaryButtonStyle(BuildContext context,
      {FontWeight? fontWeight}) {
    return _baseButtonStyle(mediumButtonFontSize, fontWeight: fontWeight)
        .copyWith(
      backgroundColor: createButtonStyleColor(primaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(primaryButtonColorText(context)),
    );
  }

  static ButtonStyle mediumSecondaryButtonStyle(BuildContext context,
      {FontWeight? fontWeight}) {
    return _baseButtonStyle(mediumButtonFontSize, fontWeight: fontWeight)
        .copyWith(
      backgroundColor: createButtonStyleColor(secondaryButtonColor(context)),
      foregroundColor:
          createButtonStyleColor(secondaryButtonColorText(context)),
    );
  }

  // Tools

  static WidgetStateProperty<Color> createButtonStyleColor(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return color.withAlpha(20);
      }
      return color;
    });
  }

  // Custom

  static ButtonStyle manyToManyOptionButtonStyle(BuildContext context) {
    double fontSize = 18;
    return _baseButtonStyle(fontSize, fontWeight: FontWeight.normal).copyWith(
      side: WidgetStateProperty.all(
          BorderSide(color: tertiaryButtonBorderColor(context), width: 2)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(BorderStyles.bigBorderRadiusValue)),
      )),
      backgroundColor: createButtonStyleColor(tertiaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(tertiaryButtonColorText(context)),
    );
  }
}
