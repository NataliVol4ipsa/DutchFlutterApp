import 'package:dutch_app/domain/models/base_word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class Word extends BaseWord {
  final int id;

  Word(this.id, super.dutchWord, super.englishWord, super.partOfSpeech,
      {super.collection,
      super.deHetType = DeHetType.none,
      super.pluralForm,
      super.contextExample,
      super.contextExampleTranslation,
      super.userNote,
      super.audioCode});

  String toDutchWordString() {
    if (deHetType != DeHetType.none && partOfSpeech == PartOfSpeech.noun) {
      return "${deHetType.label} $dutchWord";
    }

    return dutchWord;
  }
}
