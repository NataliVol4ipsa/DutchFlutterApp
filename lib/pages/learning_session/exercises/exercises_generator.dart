import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/pages/learning_session/exercises/base/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/exercise_type.dart';
import 'package:first_project/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:first_project/pages/learning_session/exercises/write/write_exercise.dart';

class ExercisesGenerator {
  final List<ExerciseType> exerciseTypes;
  final List<Word> words;

  ExercisesGenerator(this.exerciseTypes, this.words);

  List<BaseExercise> generateExcercises() => <BaseExercise>[
        ...generateDeHetExcercises(),
        ...generateFlipCardExcercises(),
      ];

  List<BaseExercise> generateDeHetExcercises() {
    if (!exerciseTypes.contains(ExerciseType.deHetPick)) return [];

    List<Word> supportedWords =
        words.where((w) => DeHetPickExercise.isSupportedWord(w)).toList();
    var exercises =
        supportedWords.map((word) => DeHetPickExercise(word)).toList();

    return exercises;
  }

  List<BaseExercise> generateFlipCardExcercises() {
    if (!exerciseTypes.contains(ExerciseType.flipCard)) return [];

    List<Word> supportedWords =
        words.where((w) => FlipCardExercise.isSupportedWord(w)).toList();
    var exercises =
        supportedWords.map((word) => FlipCardExercise(word)).toList();

    return exercises;
  }

  List<BaseExercise> generateWritingExcercises() {
    if (!exerciseTypes.contains(ExerciseType.basicWrite)) return [];

    List<Word> supportedWords =
        words.where((w) => WriteExercise.isSupportedWord(w)).toList();
    var exercises = supportedWords.map((word) => WriteExercise(word)).toList();

    return exercises;
  }
}
