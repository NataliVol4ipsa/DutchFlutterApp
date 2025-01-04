import 'package:dutch_app/pages/learning_session/summary/card_builder.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SummaryTotalCardsBuilder {
  final SessionSummary summary;

  SummaryTotalCardsBuilder({required this.summary});

  Widget buildWordsTotalCard() {
    String text = summary.totalWords > 1 ? "Words" : "Word";
    return CardBuilder.buildTotalCard(text, summary.totalWords.toString());
  }

  Widget buildExercisesTotalCard() {
    String text = summary.totalExercises > 1 ? "Exercises" : "Exercise";
    return CardBuilder.buildTotalCard(text, summary.totalExercises.toString());
  }

  Widget buildExerciseTypesTotalCard() {
    String text =
        summary.totalExerciseTypes > 1 ? "Exercise Types" : "Exercise Type";
    return CardBuilder.buildTotalCard(
        text, summary.totalExerciseTypes.toString());
  }

  Widget buildMistakesTotalCard() {
    String text = summary.totalMistakes > 1 || summary.totalMistakes == 0
        ? "Mistakes"
        : "Mistake";
    return CardBuilder.buildTotalCard(text, summary.totalMistakes.toString(),
        statColorOverride: CardBuilder.mistakesColor(summary.totalMistakes));
  }

  Widget buildMistakesRateTotalCard() {
    String text = "Mistakes rate";
    return CardBuilder.buildTotalCard(
        text, CardBuilder.percentToString(summary.mistakeRatePercent),
        statColorOverride:
            CardBuilder.mistakeRateColor(summary.mistakeRatePercent));
  }

  Widget buildSuccessRateTotalCard() {
    String text = "Success rate";
    return CardBuilder.buildTotalCard(
      text,
      CardBuilder.percentToString(summary.successRatePercent),
      titleStyleOverride: TextStyles.sessionSummaryAttentionStatTitleStyle,
      statStyleOverride: TextStyles.sessionSummaryAttentionStatStyle,
    );
  }
}
