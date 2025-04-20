import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishTranslation {
  OnlineTranslationDutchWord mainWord;
  List<OnlineTranslationDutchWord> synonyms;
  List<String> englishWords;
  List<WordType> partOfSpeech;
  DeHetType? article;
  late List<SentenceExample> sentenceExamples;
  late int translationScore;
  DutchToEnglishTranslation(
    this.mainWord,
    this.synonyms,
    this.englishWords,
    this.partOfSpeech,
    this.article, {
    List<SentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
    translationScore = 0;
    translationScore += englishWords.isNotEmpty ? 10 : 0;
    translationScore += partOfSpeech.isNotEmpty ? 5 : 0;
    translationScore += article != null && article != DeHetType.none ? 3 : 0;
    translationScore += sentenceExamples!.isNotEmpty ? 2 : 0;
    translationScore += synonyms.isNotEmpty ? 1 : 0;
  }
}
