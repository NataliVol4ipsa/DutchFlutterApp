import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class BaseWord {
  final String dutchWord;
  final String englishWord;
  final WordType wordType;
  final DeHetType deHetType;
  final String? pluralForm;
  final WordCollection? collection;
  final String? contextExample;
  final String? contextExampleTranslation;
  final String? userNote;

  BaseWord(this.dutchWord, this.englishWord, this.wordType,
      {this.collection,
      this.deHetType = DeHetType.none,
      this.pluralForm,
      this.contextExample,
      this.contextExampleTranslation,
      this.userNote});
}
