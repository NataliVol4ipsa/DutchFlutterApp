import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';

class WordExercisesToUnlock {
  final Word word;
  final List<ExerciseTypeDetailed> newlyUnlocked;

  const WordExercisesToUnlock({
    required this.word,
    required this.newlyUnlocked,
  });
}
