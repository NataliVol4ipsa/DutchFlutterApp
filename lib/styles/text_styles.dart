import 'package:first_project/styles/base_styles.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const Color evaluationSuccessTextColor = Colors.green;
  static const Color evaluationErrorTextColor = Colors.red;

  static const TextStyle exerciseEvaluationTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final TextStyle successEvaluationStyle =
      exerciseEvaluationTextStyle.copyWith(color: evaluationSuccessTextColor);
  static final TextStyle failureEvaluationStyle =
      exerciseEvaluationTextStyle.copyWith(color: evaluationErrorTextColor);

  static TextStyle exercisePromptStyle(BuildContext context) {
    var colorScheme = BaseStyles.getColorScheme(context);

    var textColor = colorScheme.onPrimaryContainer;

    return TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: textColor);
  }

  static TextStyle exerciseInputDataStyle(BuildContext context) {
    var colorScheme = BaseStyles.getColorScheme(context);

    var textColor = colorScheme.onSurfaceVariant;

    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: textColor);
  }
}
