import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishTranslation {
  List<OnlineTranslationDutchWord> dutchWords;
  List<String> englishWords;
  PartOfSpeech partOfSpeech;
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
