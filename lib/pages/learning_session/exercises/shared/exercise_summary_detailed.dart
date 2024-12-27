import 'package:first_project/core/types/exercise_type.dart';

class ExerciseSummaryDetailed {
  final int wordId;
  final ExerciseType exerciseType;
  final int totalCorrectAnswers;
  final int totalWrongAnswers;

  ExerciseSummaryDetailed(
      {required this.wordId,
      required this.exerciseType,
      required this.totalCorrectAnswers,
      required this.totalWrongAnswers});
}
