import 'package:dutch_app/core/models/base_word.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class Word extends BaseWord {
  final int id;

  Word(
    this.id,
    super.dutchWord,
    super.englishWord,
    super.wordType, {
    super.collection,
    super.deHetType = DeHetType.none,
    super.pluralForm,
    super.contextExample,
    super.contextExampleTranslation,
    super.userNote,
  });

  String toDutchWordString() {
    if (deHetType != DeHetType.none && wordType == WordType.noun) {
      return "${deHetType.label} $dutchWord";
    }

    return dutchWord;
  }
}
