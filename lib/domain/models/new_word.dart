import 'package:dutch_app/domain/models/base_word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';

class NewWord extends BaseWord {
  NewWord(
    super.dutchWord,
    super.englishWords,
    super.wordType, {
    super.collection,
    super.deHetType = DeHetType.none,
    super.pluralForm,
    super.contextExample,
    super.contextExampleTranslation,
    super.userNote,
  });
}
