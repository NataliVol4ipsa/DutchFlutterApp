import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningModesManager {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  LearningModesManager(this.learningModes, this.words);
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

  bool isSupportedWord(Word word);
}

// from pool of words, select words that are isSupportedWord
// pick numOfRequiredWords from the relevant pool and create modes for them
class SimpleLearningModeData extends BaseLearningModeData {
  SimpleLearningModeData(int numOfRequiredWords)
      : super(numOfRequiredWords, LearningModeType.flipCard, true, true);

  @override
  bool isSupportedWord(Word word) {
    // TODO: implement isSupportedWord
    throw UnimplementedError();
  }
}
