import 'package:dutch_app/core/services/practice_session_stateful_service.dart';
import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/summary/exercise_total_cards_builder.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/pages/learning_session/summary/summary_totals_widget.dart';
import 'package:dutch_app/reusable_widgets/section_container_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// todo animate main stats numbers slowly appear on screen.
// rushing through all numbers from 1 to N.
// success rate is last one, and it fades from transparent opacity to full opacity
// then a nice super sticker slaps under 45 degree at top right corner of screen
// if success rate is 100%
// this sticker contains different phrases, appraising user.
// Wow, cool, super, amazing, bravo, your dog is proud of you, etc.
// if user taps again - speed up animations.
// test on slower devices
class SessionSummaryWidget extends StatelessWidget {
  final SessionSummary summary;

  const SessionSummaryWidget({
    super.key,
    required this.summary,
  });

  List<Widget> _buildSummaryPerExercise(BuildContext context) {
    return summary.summariesPerExercise
        .map((e) => _buildExerciseSummary(e, context))
        .toList();
  }

  Widget _buildExerciseSummary(
      SingleExerciseTypeSummary summary, BuildContext context) {
    return SectionContainer(
      padding: ContainerStyles.containerPadding,
      child: Column(
        children: [
          Text(
            summary.exerciseType.label,
            style: TextStyles.sessionSummaryTitleTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ExerciseTotalsCardsBuilder.buildWordsTotalCard(context, summary),
              ExerciseTotalsCardsBuilder.buildMistakesTotalCard(
                  context, summary),
              ExerciseTotalsCardsBuilder.buildSuccessRateTotalCard(
                  context, summary),
              ExerciseTotalsCardsBuilder.buildMistakesRateTotalCard(
                  context, summary),
            ],
          ),
          if (summary.totalMistakes > 0) ...{
            Column(
              children: [
                const Padding(
                  padding: ContainerStyles.containerPadding,
                  child: Text(
                    "Top 5 Words to improve:",
                    textAlign: TextAlign.left,
                    style: TextStyles.sessionSummarySubtitleTextStyle,
                  ),
                ),
                Container(
                    padding: ContainerStyles.containerPadding,
                    width: double.infinity,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderStyles.bigBorderRadius,
                      color: ContainerStyles.section2Color(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _buildImprovementRecommendations(summary, context),
                    )),
              ],
            ),
          },
        ],
      ),
    );
  }

  List<Widget> _buildImprovementRecommendations(
      SingleExerciseTypeSummary singleExerciseTypeSummary,
      BuildContext context) {
    var top5Summaries = (singleExerciseTypeSummary.summaries
            .where((item) => item.totalWrongAnswers > 0)
            .toList()
          ..sort((a, b) => b.totalWrongAnswers.compareTo(a.totalWrongAnswers)))
        .take(5);

    return top5Summaries
        .map((summary) => _buildWordStat(context, summary))
        .toList();
  }

  Widget _buildWordStat(BuildContext context, ExerciseSummaryDetailed summary) {
    return Padding(
      padding: ContainerStyles.smallContainerPadding,
      child: RichText(
          text: TextSpan(
              style: TextStyles.sessionSummaryCardtitleTextStyle(context),
              children: <TextSpan>[
            TextSpan(text: summary.correctAnswer),
            const TextSpan(text: " ("),
            TextSpan(
                text: summary.totalWrongAnswers.toString(),
                style: const TextStyle(color: TextStyles.failureTextColor)),
            TextSpan(
                text: summary.totalWrongAnswers == 1 ? " mistake" : " mistakes",
                style: const TextStyle(color: TextStyles.failureTextColor)),
            const TextSpan(text: ")"),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> contentSections = [
      SummaryTotals(summary: summary),
      ..._buildSummaryPerExercise(context),
    ];

    return BaseExerciseLayout(
      contentBuilder: (context) {
        return ListView.builder(
          itemCount: contentSections.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: ContainerStyles.betweenCardsPadding,
              child: contentSections[index],
            );
          },
        );
      },
      footerBuilder: (context) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _onCompletePressed(context),
                style: ButtonStyles.largeWidePrimaryButtonStyle(context),
                child: const Text(
                  "Back to menu",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _onCompletePressed(BuildContext context) {
    var service = context.read<PracticeSessionStatefulService>();
    service.cleanup();
    Navigator.pop(context);
  }
}
