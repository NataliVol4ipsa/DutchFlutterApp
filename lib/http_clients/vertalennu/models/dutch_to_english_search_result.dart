import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';

class DutchToEnglishSearchResult {
  List<DutchToEnglishTranslation> translations;
  late List<SentenceExample> sentenceExamples;
  DutchToEnglishSearchResult(
    this.translations, {
    List<SentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
  }
}
