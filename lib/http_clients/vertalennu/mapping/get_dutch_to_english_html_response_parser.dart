import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_search_result.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

class GetDutchToEnglishHtmlResponseParser {
  DutchToEnglishSearchResult parseResponse(String htmlString) {
    final List<DutchToEnglishTranslation> translationResults = [];
    final rootExamples = <SentenceExample>[];

    final document = html_parser.parse(htmlString);

    _processTranslations(document, translationResults);
    _processRootExampleSentences(document, rootExamples);

    return DutchToEnglishSearchResult(
      translationResults,
      sentenceExamples: rootExamples,
    );
  }

  void _processTranslations(
      Document document, List<DutchToEnglishTranslation> translationResults) {
    final translationRows = document.querySelectorAll('.result-item-row');

    for (final row in translationRows) {
      final dutchWords = row
          .querySelectorAll('.result-item-source .wordentry')
          .map((e) => e.text.trim())
          .toList();

      final englishWords = row
          .querySelectorAll('.result-item-target .wordentry')
          .map((e) => e.text.trim())
          .toList();

      final partOfSpeech = row
          .querySelectorAll('.result-item-source .additional abbr')
          .map((e) => e.attributes['title']?.trim() ?? '')
          .toList();

      final examples = <SentenceExample>[];

      _processTranslationExampleSentences(row, examples);

      if (dutchWords.isNotEmpty && englishWords.isNotEmpty) {
        translationResults.add(
          DutchToEnglishTranslation(dutchWords, englishWords, partOfSpeech,
              sentenceExamples: examples),
        );
      }
    }
  }

  void _processTranslationExampleSentences(
      Element row, List<SentenceExample> examples) {
    final exampleRows = row.querySelectorAll('.result-item-examples');
    for (final exRow in exampleRows) {
      final cols = exRow.querySelectorAll('.result-example');
      if (cols.length >= 2) {
        final nlHtml = cols[0].innerHtml.trim();
        final enHtml = cols[1].innerHtml.trim();
        examples.add(SentenceExample(nlHtml, enHtml));
      }
    }
  }

  void _processRootExampleSentences(
      Document document, List<SentenceExample> rootExamples) {
    // Root-level sentence examples under #voorbeelden
    final exampleRows = document.querySelectorAll('.result-item-phrasebook');

    for (final row in exampleRows) {
      final nlHtml =
          row.querySelector('.result-item-source p')?.innerHtml.trim() ?? '';
      final enHtml =
          row.querySelector('.result-item-target p')?.innerHtml.trim() ?? '';
      if (nlHtml.isNotEmpty && enHtml.isNotEmpty) {
        rootExamples.add(SentenceExample(nlHtml, enHtml));
      }
    }
  }
}
