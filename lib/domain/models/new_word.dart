import 'package:dutch_app/domain/models/base_word.dart';

class NewWord extends BaseWord {
  NewWord(super.dutchWord, super.englishWords, super.partOfSpeech,
      {super.collection,
      super.contextExample,
      super.contextExampleTranslation,
      super.userNote,
      super.nounDetails,
      super.verbDetails});
}
