import 'package:dutch_app/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';

class ExercisesGenerator {
  final List<ExerciseType> exerciseTypes;
  final List<Word> words;

  ExercisesGenerator(this.exerciseTypes, this.words);

  List<BaseExercise> generateExcercises() => <BaseExercise>[
        ...generateDeHetExcercises(),
        ...generateFlipCardExcercises(),
        ...generateManyToManyExcercises(),
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

  List<BaseExercise> generateManyToManyExcercises() {
    if (!exerciseTypes.contains(ExerciseType.manyToMany)) return [];

    List<Word> supportedWords =
        words.where((w) => ManyToManyExercise.isSupportedWord(w)).toList();

    if (supportedWords.length < 2) return [];

    List<BaseExercise> exercises = [];

    //2..5=> 1 chunk
    //6  => 2 chunks, 3+3 or 4+2
    //7 => 5+2? 4+3?
    //8 =? 5 + 3 ? 4 + 4?
    //9 => 5 + 4
    //10 => 5 + 5
    for (int i = 0;
        i < supportedWords.length;
        i += ManyToManyExercise.requiredWords) {
      List<Word> wordsChunk = supportedWords.sublist(
          i,
          (i + ManyToManyExercise.requiredWords)
              .clamp(0, supportedWords.length));

      exercises.add(ManyToManyExercise(wordsChunk));
    }

    //todo handle 6 words

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
