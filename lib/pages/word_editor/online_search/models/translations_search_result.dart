import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';

class TranslationsSearchResult {
  List<TranslationSearchResult> translations;
  late List<TranslationSearchResultSentenceExample> sentenceExamples;
  TranslationsSearchResult(
    this.translations, {
    List<TranslationSearchResultSentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
  }
}
