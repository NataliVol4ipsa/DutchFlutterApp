import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const Color successTextColor = Colors.green;
  static const Color failureTextColor = Colors.red;

  static const TextStyle exerciseEvaluationTextStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final TextStyle successEvaluationStyle =
      exerciseEvaluationTextStyle.copyWith(color: successTextColor);
  static final TextStyle failureEvaluationStyle =
      exerciseEvaluationTextStyle.copyWith(color: failureTextColor);

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

  static TextStyle exerciseInputDataHintStyle(BuildContext context) {
    return exerciseInputDataStyle(context).copyWith(fontSize: 14);
  }

  static TextStyle exerciseInputDataAnswerStyle(BuildContext context) {
    return exerciseInputDataStyle(context).copyWith(color: successTextColor);
  }

  static const TextStyle sessionSummaryTitleTextStyle =
      TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

  static const TextStyle sessionSummarySubtitleTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle sessionSummaryCardtitleTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static const TextStyle sessionSummaryGoodStatStyle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: successTextColor);

  static const TextStyle sessionSummaryNeutralStatStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle sessionSummaryBadStatStyle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: failureTextColor);

  static const TextStyle sessionSummaryAttentionStatTitleStyle =
      TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

  static const TextStyle sessionSummaryAttentionStatStyle = TextStyle(
      fontSize: 32, fontWeight: FontWeight.bold, color: successTextColor);

  static const TextStyle settingsTitleStyle = TextStyle(fontSize: 18);
}
