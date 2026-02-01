import 'package:dutch_app/domain/types/exercise_type_detailed.dart';

class WordProgressKey {
  final int wordId;
  final ExerciseTypeDetailed exerciseType;

  const WordProgressKey(this.wordId, this.exerciseType);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordProgressKey &&
        other.wordId == wordId &&
        other.exerciseType == exerciseType;
  }

  @override
  int get hashCode => Object.hash(wordId, exerciseType);
}
