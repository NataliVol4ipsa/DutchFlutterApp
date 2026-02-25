import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';

class ExerciseSummaryDetailed {
  final Word word;
  final ExerciseType exerciseType;
  final int totalCorrectAnswers;
  final int totalWrongAnswers;
  final String correctAnswer;

  /// Set only for Anki-mode exercises. Null for simplified know/don't-know mode.
  final AnkiGrade? ankiGrade;

  int get wordId => word.id;

  ExerciseSummaryDetailed({
    required this.word,
    required this.exerciseType,
    required this.totalCorrectAnswers,
    required this.totalWrongAnswers,
    required this.correctAnswer,
    this.ankiGrade,
  });
}
