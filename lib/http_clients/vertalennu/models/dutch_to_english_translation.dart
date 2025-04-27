import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishTranslation {
  List<OnlineTranslationDutchWord> dutchWords;
  List<String> englishWords;
  WordType partOfSpeech;
  late List<SentenceExample> sentenceExamples;
  DutchToEnglishTranslation(
    this.dutchWords,
    this.englishWords,
    this.partOfSpeech, {
    List<SentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
  }
}
