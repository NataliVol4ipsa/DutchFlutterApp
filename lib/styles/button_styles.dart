import 'package:first_project/styles/base_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyles extends BaseStyles {
  static final ButtonStyle primaryButtonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )));

  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    var colorScheme = BaseStyles.getColorScheme(context);

    var textColor = colorScheme.onPrimaryContainer;
    var backgroundColor = colorScheme.primaryContainer;

    return primaryButtonStyle.copyWith(
      backgroundColor: _createButtonStyleColor(backgroundColor),
      foregroundColor: _createButtonStyleColor(textColor),
    );
  }

  // Tools

  static MaterialStateProperty<Color> _createButtonStyleColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return color.withOpacity(0.5);
      }
      return color;
    });
  }
}
