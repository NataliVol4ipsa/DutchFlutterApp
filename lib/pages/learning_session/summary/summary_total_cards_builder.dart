import 'package:first_project/pages/learning_session/summary/session_summary.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SummaryTotalCardsBuilder {
  final SessionSummary summary;

  SummaryTotalCardsBuilder({required this.summary});

  Widget buildWordsTotalCard() {
    String text = summary.totalWords > 1 ? "Words" : "Word";
    return _buildTotalCard(text, summary.totalWords.toString());
  }

  Widget buildExercisesTotalCard() {
    String text = summary.totalExercises > 1 ? "Exercises" : "Exercise";
    return _buildTotalCard(text, summary.totalExercises.toString());
  }

  Widget buildExerciseTypesTotalCard() {
    String text =
        summary.totalExerciseTypes > 1 ? "Exercise Types" : "Exercise Type";
    return _buildTotalCard(text, summary.totalExerciseTypes.toString());
  }

  Widget buildMistakesTotalCard() {
    String text = summary.totalMistakes > 1 || summary.totalMistakes == 0
        ? "Mistakes"
        : "Mistake";
    return _buildTotalCard(text, summary.totalMistakes.toString(),
        statColorOverride: _mistakesColor(summary.totalMistakes));
  }

  Widget buildMistakesRateTotalCard() {
    String text = "Mistakes rate";
    return _buildTotalCard(text, _percentToString(summary.mistakeRatePercent),
        statColorOverride: _mistakeRateColor(summary.mistakeRatePercent));
  }

  Widget buildSuccessRateTotalCard() {
    String text = "Success rate";
    return _buildTotalCard(
      text,
      _percentToString(summary.successRatePercent),
      titleStyleOverride: TextStyles.sessionSummaryAttentionStatTitleStyle,
      statStyleOverride: TextStyles.sessionSummaryAttentionStatStyle,
    );
  }

  Widget _buildTotalCard(String title, String stat,
      {TextStyle? titleStyleOverride,
      TextStyle? statStyleOverride,
      Color? statColorOverride}) {
    return Expanded(
      child: Padding(
        padding: ContainerStyles.smallContainerPadding,
        child: Column(
          children: [
            Text(stat,
                style: statStyleOverride ??
                    TextStyles.sessionSummaryNeutralStatStyle.copyWith(
                        color: statColorOverride ??
                            TextStyles.sessionSummaryNeutralStatStyle.color)),
            Text(title,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titleStyleOverride ??
                    TextStyles.sessionSummarySubtitleTextStyle),
          ],
        ),
      ),
    );
  }

  Color _mistakesColor(int mistakes) {
    if (mistakes == 0) {
      return TextStyles.successTextColor;
    }
    return TextStyles.failureTextColor;
  }

  Color _mistakeRateColor(double mistakesRate) {
    if (mistakesRate == 0) {
      return TextStyles.successTextColor;
    }
    return TextStyles.failureTextColor;
  }

  String _percentToString(double percent) {
    return "${percent.toStringAsFixed(0)}%";
  }
}
