import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
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

  static TextStyle sessionSummaryCardtitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: ContainerStyles.section2TextColor(context),
    );
  }

  static TextStyle bottomAppBarTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 20,
      color: color,
    );
  }

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

  static const TextStyle modalDescriptionTextStyle = TextStyle(fontSize: 16);

  static const TextStyle titleStyle =
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  static const TextStyle titleCommentStyle =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);

  static const TextStyle wordDetailsSectionTitleStyle =
      TextStyle(fontSize: 15, fontStyle: FontStyle.italic);

  static const TextStyle wordDetailsSectionContentStyle =
      TextStyle(fontSize: 18);

  static const TextStyle smallWordDetailsSectionContentStyle =
      TextStyle(fontSize: 18, fontStyle: FontStyle.italic);

  static Color dropdownGreyTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface.withAlpha(100);
}
