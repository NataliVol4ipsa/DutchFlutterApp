import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishSearchResponse {
  List<DutchToEnglishTranslation> translations;
  final String searchedWord;
  late List<SentenceExample> sentenceExamples;

  DutchToEnglishSearchResponse(
    this.translations,
    this.searchedWord, {
    List<SentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
  }
}
