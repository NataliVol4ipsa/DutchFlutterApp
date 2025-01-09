import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle bigButtonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
      minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )));

  static ButtonStyle primaryButtonStyle(BuildContext context) {
    var colorScheme = BaseStyles.getColorScheme(context);

    var textColor = colorScheme.onPrimaryContainer;
    var backgroundColor = colorScheme.primaryContainer;

    return bigButtonStyle.copyWith(
      backgroundColor: createButtonStyleColor(backgroundColor),
      foregroundColor: createButtonStyleColor(textColor),
    );
  }

  // Tools

  static WidgetStateProperty<Color> createButtonStyleColor(Color color) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return color.withAlpha(12);
      }
      return color;
    });
  }
}
