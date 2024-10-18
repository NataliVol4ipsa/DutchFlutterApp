import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';

class Word {
  final int? id;
  final String dutchWord;
  final String englishWord;
  final WordType wordType;
  DeHetType deHetType;
  String? pluralForm;
  String? tag;

  Word(
    this.id,
    this.dutchWord,
    this.englishWord,
    this.wordType, {
    this.deHetType = DeHetType.none,
    this.pluralForm,
    this.tag,
  });
}
