import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishTranslation {
  List<OnlineTranslationDutchWord> dutchWords;
  List<String> englishWords;
  List<WordType> partOfSpeech;
  DeHetType? article;
  late List<SentenceExample> sentenceExamples;
  DutchToEnglishTranslation(
    this.dutchWords,
    this.englishWords,
    this.partOfSpeech,
    this.article, {
    List<SentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
  }
}

class OnlineTranslationDutchWord {
  String word;
  GenderType? gender;
  DeHetType? article;
  OnlineTranslationDutchWord(this.word, {this.gender, this.article});
}
