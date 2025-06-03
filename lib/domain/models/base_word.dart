import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class BaseWord {
  final String dutchWord;
  final List<String> englishWords;
  final PartOfSpeech partOfSpeech;
  final DeHetType deHetType;
  final String? pluralForm;
  final WordCollection? collection;
  final String? contextExample;
  final String? contextExampleTranslation;
  final String? userNote;
  final String? audioCode;

  BaseWord(this.dutchWord, this.englishWords, this.partOfSpeech,
      {this.collection,
      this.deHetType = DeHetType.none,
      this.pluralForm,
      this.contextExample,
      this.contextExampleTranslation,
      this.userNote,
      this.audioCode});
}
