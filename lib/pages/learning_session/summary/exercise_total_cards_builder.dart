import 'package:first_project/pages/learning_session/summary/card_builder.dart';
import 'package:first_project/pages/learning_session/summary/session_summary.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

//todo refactor and reuse other cards
class ExerciseTotalsCardsBuilder {
  static Widget buildWordsTotalCard(SingleExerciseTypeSummary summary) {
    String text = summary.totalWords > 1 ? "Words" : "Word";
    return CardBuilder.buildTotalCard(text, summary.totalWords.toString());
  }

  static Widget buildMistakesTotalCard(SingleExerciseTypeSummary summary) {
    String text = summary.totalMistakes > 1 || summary.totalMistakes == 0
        ? "Mistakes"
        : "Mistake";
    return CardBuilder.buildTotalCard(text, summary.totalMistakes.toString());
  }

  static Widget buildSuccessRateTotalCard(SingleExerciseTypeSummary summary) {
    String text = "Success rate";
    return CardBuilder.buildTotalCard(
      text,
      CardBuilder.percentToString(summary.successRatePercent),
      statColorOverride: _successColor(summary.successRatePercent),
    );
  }

  static Widget buildMistakesRateTotalCard(SingleExerciseTypeSummary summary) {
    String text = "Mistakes rate";
    return CardBuilder.buildTotalCard(
        text, CardBuilder.percentToString(summary.mistakeRatePercent));
  }

  static Color? _successColor(double successRate) {
    if (successRate >= 99.8) {
      return TextStyles.successTextColor;
    }

    return null;
  }
}
