import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/de_het_pick_learning_mode_task.dart';
import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/flip_card_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningModesManager {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  LearningModesManager(this.learningModes, this.words);

  List<BaseLearningModeTask> generateExcercises() {
    List<Word> supportedWords = words
        .where((w) => DeHetPickLearningModeTask.isSupportedWord(w))
        .toList();

    var flipCardTasks =
        supportedWords.map((word) => DeHetPickLearningModeTask(word)).toList();

    return flipCardTasks;
  }

  List<BaseLearningModeTask> generateFlipCardExcercises() {
    List<Word> supportedWords = words
        .where((w) => FlipCardLearningModeTask.isSupportedWord(w))
        .toList();

    List<FlipCardLearningModeTask> flipCardDataList =
        supportedWords.map((word) => FlipCardLearningModeTask(word)).toList();

    return flipCardDataList;
  }
}
