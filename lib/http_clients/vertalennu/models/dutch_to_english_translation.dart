import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishTranslation {
  List<String> dutchWords;
  List<String> englishWords;
  List<String> partOfSpeech;
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
