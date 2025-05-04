import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';

class SessionSummary {
  final int totalWords;
  final int totalExercises;
  final List<ExerciseType> exerciseTypes;
  final List<ExerciseSummaryDetailed> detailedSummaries;

  late int totalExerciseTypes;
  late int totalMistakes;
  late double successRatePercent;
  late double mistakeRatePercent;
  late List<SingleExerciseTypeSummary> summariesPerExercise;

  SessionSummary(
      {required this.totalWords,
      required this.totalExercises,
      required this.exerciseTypes,
      required this.detailedSummaries}) {
    totalExerciseTypes = exerciseTypes.length;

    totalMistakes = detailedSummaries.fold(
      0,
      (sum, detail) => sum + detail.totalWrongAnswers,
    );
    int totalAttempts = totalExercises + totalMistakes;
    mistakeRatePercent =
        totalExercises > 0 ? (totalMistakes * 100 / totalAttempts) : 0;
    successRatePercent = 100 - mistakeRatePercent;

    exerciseTypes.sort((a, b) => a.toString().compareTo(b.toString()));

    summariesPerExercise = exerciseTypes
        .map((exerciseType) => SingleExerciseTypeSummary(
            exerciseType: exerciseType, detailedSummaries: detailedSummaries))
        .toList();
  }
}

class SingleExerciseTypeSummary {
  final ExerciseType exerciseType;
  late List<ExerciseSummaryDetailed> summaries;
  late int totalMistakes;
  late double successRatePercent;
  late double mistakeRatePercent;

  late int totalWords;

  SingleExerciseTypeSummary(
      {required this.exerciseType,
      required List<ExerciseSummaryDetailed> detailedSummaries}) {
    summaries =
        detailedSummaries.where((s) => s.exerciseType == exerciseType).toList();

    totalWords = summaries.length;

    totalMistakes = summaries.fold(
      0,
      (sum, detail) => sum + detail.totalWrongAnswers,
    );
    int totalAttempts = totalWords + totalMistakes;
    mistakeRatePercent = totalMistakes * 100 / totalAttempts;
    successRatePercent = 100 - mistakeRatePercent;
  }
}
