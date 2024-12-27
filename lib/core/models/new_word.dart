import 'package:first_project/core/models/base_word.dart';
import 'package:first_project/core/types/de_het_type.dart';

class NewWord extends BaseWord {
  NewWord(
    super.dutchWord,
    super.englishWord,
    super.wordType, {
    super.deHetType = DeHetType.none,
    super.pluralForm,
    super.tag,
    super.collection,
  });
}
