import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/exercise_type.dart';

class ExerciseSummaryDetailed {
  final Word word;
  final ExerciseType exerciseType;
  final int totalCorrectAnswers;
  final int totalWrongAnswers;
  final String correctAnswer;

  int get wordId => word.id;

  ExerciseSummaryDetailed(
      {required this.word,
      required this.exerciseType,
      required this.totalCorrectAnswers,
      required this.totalWrongAnswers,
      required this.correctAnswer});
}
