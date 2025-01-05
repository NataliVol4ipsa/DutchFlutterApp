import 'package:dutch_app/pages/learning_session/summary/card_builder.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SummaryTotalCardsBuilder {
  final SessionSummary summary;

  SummaryTotalCardsBuilder({required this.summary});

  Widget buildWordsTotalCard(BuildContext context) {
    String text = summary.totalWords > 1 ? "Words" : "Word";
    return CardBuilder.buildTotalCard(
        context, text, summary.totalWords.toString());
  }

  Widget buildExercisesTotalCard(BuildContext context) {
    String text = summary.totalExercises > 1 ? "Exercises" : "Exercise";
    return CardBuilder.buildTotalCard(
        context, text, summary.totalExercises.toString());
  }

  Widget buildExerciseTypesTotalCard(BuildContext context) {
    String text =
        summary.totalExerciseTypes > 1 ? "Exercise Types" : "Exercise Type";
    return CardBuilder.buildTotalCard(
        context, text, summary.totalExerciseTypes.toString());
  }

  Widget buildMistakesTotalCard(BuildContext context) {
    String text = summary.totalMistakes > 1 || summary.totalMistakes == 0
        ? "Mistakes"
        : "Mistake";
    return CardBuilder.buildTotalCard(
        context, text, summary.totalMistakes.toString(),
        statColorOverride: CardBuilder.mistakesColor(summary.totalMistakes));
  }

  Widget buildMistakesRateTotalCard(BuildContext context) {
    String text = "Mistakes rate";
    return CardBuilder.buildTotalCard(
        context, text, CardBuilder.percentToString(summary.mistakeRatePercent),
        statColorOverride:
            CardBuilder.mistakeRateColor(summary.mistakeRatePercent));
  }

  Widget buildSuccessRateTotalCard(BuildContext context) {
    String text = "Success rate";
    return CardBuilder.buildTotalCard(
      context,
      text,
      CardBuilder.percentToString(summary.successRatePercent),
      titleStyleOverride: TextStyles.sessionSummaryAttentionStatTitleStyle,
      statStyleOverride: TextStyles.sessionSummaryAttentionStatStyle,
    );
  }
}
