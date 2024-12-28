import 'package:first_project/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';

class SessionSummary {
  final int totalWords;
  final int totalExercises;
  final int totalExerciseTypes;
  final List<ExerciseSummaryDetailed> detailedSummaries;

  late int totalMistakes;
  late double successRatePercent;
  late double mistakeRatePercent;

  SessionSummary(
      {required this.totalWords,
      required this.totalExercises,
      required this.totalExerciseTypes,
      required this.detailedSummaries}) {
    totalMistakes = detailedSummaries.fold(
      0,
      (sum, detail) => sum + detail.totalWrongAnswers,
    );

    int totalAttempts = totalExercises + totalMistakes;
    mistakeRatePercent =
        totalExercises > 0 ? (totalMistakes * 100 / totalAttempts) : 0;
    successRatePercent = 100 - mistakeRatePercent;
  }
}
