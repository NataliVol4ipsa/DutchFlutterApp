import 'package:dutch_app/pages/learning_session/summary/summary_card_builder.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

//todo refactor and reuse other cards
class ExerciseTotalsCardsBuilder {
  static Widget buildWordsTotalCard(
      BuildContext context, SingleExerciseTypeSummary summary) {
    String text = summary.totalWords > 1 ? "Words" : "Word";
    return SummaryCardBuilder.buildTotalCard(
        context, text, summary.totalWords.toString());
  }

  static Widget buildMistakesTotalCard(
      BuildContext context, SingleExerciseTypeSummary summary) {
    String text = summary.totalMistakes > 1 || summary.totalMistakes == 0
        ? "Mistakes"
        : "Mistake";
    return SummaryCardBuilder.buildTotalCard(
        context, text, summary.totalMistakes.toString());
  }

  static Widget buildSuccessRateTotalCard(
      BuildContext context, SingleExerciseTypeSummary summary) {
    String text = "Success rate";
    return SummaryCardBuilder.buildTotalCard(
      context,
      text,
      SummaryCardBuilder.percentToString(summary.successRatePercent),
      statColorOverride: _successColor(summary.successRatePercent),
    );
  }

  static Widget buildMistakesRateTotalCard(
      BuildContext context, SingleExerciseTypeSummary summary) {
    String text = "Mistakes rate";
    return SummaryCardBuilder.buildTotalCard(context, text,
        SummaryCardBuilder.percentToString(summary.mistakeRatePercent));
  }

  static Color? _successColor(double successRate) {
    if (successRate >= 99.8) {
      return TextStyles.successTextColor;
    }

    return null;
  }
}
