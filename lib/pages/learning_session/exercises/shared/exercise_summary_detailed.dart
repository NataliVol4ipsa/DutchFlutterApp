import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/exercise_type.dart';

class ExerciseSummaryDetailed {
  final Word word;
  final ExerciseType exerciseType;
  final int totalCorrectAnswers;
  final int totalWrongAnswers;

  int get wordId => word.id;

  ExerciseSummaryDetailed(
      {required this.word,
      required this.exerciseType,
      required this.totalCorrectAnswers,
      required this.totalWrongAnswers});
}
