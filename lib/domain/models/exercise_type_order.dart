import 'package:dutch_app/domain/types/exercise_type.dart';

class ExerciseTypeOrder {
  static const int masteryConsecutiveCorrect = 2;

  static const List<ExerciseType> learningOrder = [
    ExerciseType.flipCard,
    ExerciseType.basicWrite,
  ];

  static ExerciseType? nextType(ExerciseType current) {
    final idx = learningOrder.indexOf(current);
    if (idx == -1 || idx >= learningOrder.length - 1) return null;
    return learningOrder[idx + 1];
  }

  static bool isTracked(ExerciseType current) =>
      learningOrder.contains(current);
}
