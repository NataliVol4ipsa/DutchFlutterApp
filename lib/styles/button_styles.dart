import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle _baseButtonStyle(
      double horizontalPadding, double verticalPadding, double fontSize) {
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
          fontWeight: FontWeight.bold,
        )));
  }

  static final ButtonStyle mediumButtonStyle = _baseButtonStyle(20, 10, 16);
  static final ButtonStyle bigButtonStyle = _baseButtonStyle(20, 20, 20);

  static Color primaryButtonColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).primaryContainer;
  static Color primaryButtonColorText(BuildContext context) =>
      BaseStyles.getColorScheme(context).onPrimaryContainer;

  static Color secondaryButtonColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).secondaryContainer;
  static Color secondaryButtonColorText(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSecondaryContainer;

  static ButtonStyle largePrimaryButtonStyle(BuildContext context) {
    return bigButtonStyle.copyWith(
      backgroundColor: createButtonStyleColor(primaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(primaryButtonColorText(context)),
    );
  }

  static ButtonStyle mediumPrimaryButtonStyle(BuildContext context) {
    return mediumButtonStyle.copyWith(
      backgroundColor: createButtonStyleColor(primaryButtonColor(context)),
      foregroundColor: createButtonStyleColor(primaryButtonColorText(context)),
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
}
