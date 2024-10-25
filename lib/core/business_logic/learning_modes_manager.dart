import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningModesManager {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  LearningModesManager(this.learningModes, this.words);

  List<BaseLearningModeData> generateExcercises() {
    List<Word> supportedWords = words
        .where((w) => FlipCardLearningModeData.isSupportedWord(w))
        .toList();

    List<FlipCardLearningModeData> flipCardDataList =
        supportedWords.map((word) => FlipCardLearningModeData(word)).toList();

    return flipCardDataList;
  }
}

abstract class BaseLearningModeData {
  final int numOfRequiredWords;
  final LearningModeType learningModeType;
  final bool isDutchEnglishDirectionSupported;
  final bool isEnglishDutchDirectionSupported;

  BaseLearningModeData(
      this.numOfRequiredWords,
      this.learningModeType,
      this.isDutchEnglishDirectionSupported,
      this.isEnglishDutchDirectionSupported);
}

// from pool of words, select words that are isSupportedWord
// pick numOfRequiredWords from the relevant pool and create modes for them
class FlipCardLearningModeData extends BaseLearningModeData {
  static const int requiredWords = 1;
  static const LearningModeType type = LearningModeType.flipCard;
  final Word word;

  FlipCardLearningModeData(this.word) : super(requiredWords, type, true, true);

  static bool isSupportedWord(Word word) {
    return true;
  }
}
