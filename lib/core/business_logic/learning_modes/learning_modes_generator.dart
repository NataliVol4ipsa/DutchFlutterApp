import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/de_het_pick_learning_mode_task.dart';
import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningModesGenerator {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  LearningModesGenerator(this.learningModes, this.words);

  List<BaseLearningModeTask> generateExcercises() {
    List<Word> supportedWords = words
        .where((w) => DeHetPickLearningModeTask.isSupportedWord(w))
        .toList();

    var tasks =
        supportedWords.map((word) => DeHetPickLearningModeTask(word)).toList();

    return tasks;
  }
}
