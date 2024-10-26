import 'package:first_project/core/business_logic/learning_modes_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class FlipCardLearningModeTask extends BaseLearningModeTask {
  static const int requiredWords = 1;
  static const LearningModeType type = LearningModeType.flipCard;
  final Word word;

  FlipCardLearningModeTask(this.word) : super(requiredWords, type);

  static bool isSupportedWord(Word word) {
    return true;
  }
}
