import 'package:first_project/pages/learning_flow/learning_tasks/de_het/de_het_pick_learning_mode_task.dart';
import 'package:first_project/pages/learning_flow/learning_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningTasksGenerator {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  LearningTasksGenerator(this.learningModes, this.words);

  List<BaseLearningModeTask> generateExcercises() {
    List<Word> supportedWords = words
        .where((w) => DeHetPickLearningModeTask.isSupportedWord(w))
        .toList();

    var tasks =
        supportedWords.map((word) => DeHetPickLearningModeTask(word)).toList();

    return tasks;
  }
}
