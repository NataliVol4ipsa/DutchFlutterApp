import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/pages/learning_session/exercises/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class ExercisesGenerator {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  ExercisesGenerator(this.learningModes, this.words);

  List<BaseExercise> generateExcercises() {
    List<Word> supportedWords =
        words.where((w) => DeHetPickExercise.isSupportedWord(w)).toList();

    var tasks = supportedWords.map((word) => DeHetPickExercise(word)).toList();

    return tasks;
  }
}
