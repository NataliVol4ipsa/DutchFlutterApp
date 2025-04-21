import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_search_response.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

class GetDutchToEnglishHtmlResponseParser {
  DutchToEnglishSearchResponse parseResponse(
      String htmlString, String originalWord) {
    final rootExamples = <SentenceExample>[];

    final document = html_parser.parse(htmlString);

    final translationResults = _processTranslations(document, originalWord);
    _processRootExampleSentences(document, rootExamples);

    return DutchToEnglishSearchResponse(
      translationResults,
      originalWord,
      sentenceExamples: rootExamples,
    );
  }

  List<DutchToEnglishTranslation> _processTranslations(
      Document document, String originalWord) {
    List<DutchToEnglishTranslation> translationResults = [];

    final translationRows = document.querySelectorAll('.result-item-row');

    for (final row in translationRows) {
      final List<WordType> partsOfSpeech = _processPartsOfSpeech(row);
      List<OnlineTranslationDutchWord> dutchWords =
          _processDutchWords(row, partsOfSpeech);
      final englishWords = row
          .querySelectorAll('.result-item-target .wordentry')
          .map((e) => e.text.trim())
          .toList();
      List<SentenceExample> examples = _processTranslationExampleSentences(row);

      if (dutchWords.isNotEmpty && englishWords.isNotEmpty) {
        translationResults.add(
          DutchToEnglishTranslation(dutchWords, englishWords, partsOfSpeech,
              sentenceExamples: examples),
        );
      }
    }
    return translationResults;
  }

  List<OnlineTranslationDutchWord> _processDutchWords(
      Element row, List<WordType> partOfSpeech) {
    List<OnlineTranslationDutchWord> dutchWords = [];
    final sourceContainers =
        row.querySelectorAll('.result-item-source .lemma-container');
    for (final container in sourceContainers) {
      final wordEntry = container.querySelector('.wordentry');
      if (wordEntry == null) continue;

      final word = wordEntry.text.trim();
      final genderAttr =
          container.querySelector('.meta-info')?.attributes['title'];
      final articleText = container
          .querySelector('.meta-info.article')
          ?.text
          .trim()
          .toLowerCase();

      GenderType? gender;
      DeHetType? article;

      if (partOfSpeech.contains(WordType.noun)) {
        gender = _processGender(genderAttr);
        article = _processArticle(articleText);
      }

      dutchWords.add(
          OnlineTranslationDutchWord(word, gender: gender, article: article));
    }
    return dutchWords;
  }

  DeHetType? _processArticle(String? articleText) {
    if (articleText == null) {
      return null;
    }

    return articleText == '(het ~)'
        ? DeHetType.het
        : articleText == '(de ~)'
            ? DeHetType.de
            : DeHetType.none;
  }

  GenderType? _processGender(String? genderAttr) {
    final gender = genderAttr == 'mannelijk'
        ? GenderType.mannelijk
        : genderAttr == 'vrouwelijk'
            ? GenderType.vrouwelijk
            : genderAttr == 'onzijdig'
                ? GenderType.onzijdig
                : GenderType.none;
    return gender;
  }

  List<SentenceExample> _processTranslationExampleSentences(Element row) {
    final examples = <SentenceExample>[];
    final exampleRows = row.querySelectorAll('.result-item-examples');
    for (final exRow in exampleRows) {
      final cols = exRow.querySelectorAll('.result-example');
      if (cols.length >= 2) {
        final nlHtml = cols[0].innerHtml.trim();
        final enHtml = cols[1].innerHtml.trim();
        examples.add(SentenceExample(nlHtml, enHtml));
      }
    }
    return examples;
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

  List<WordType> _processPartsOfSpeech(Element row) {
    final partOfSpeechItems = row
        .querySelectorAll('.result-item-source .additional abbr')
        .map((e) => e.attributes['title']?.trim() ?? '')
        .toList();

    List<WordType> result = [];
    for (final item in partOfSpeechItems) {
      switch (item.toLowerCase()) {
        case "zelfstandig naamwoord":
          result.add(WordType.noun);
          break;
        case "werkwoord":
          result.add(WordType.verb);
          break;
        case "bijvoeglijk naamwoord":
          result.add(WordType.adjective);
          break;
        case "bijwoord":
          result.add(WordType.adverb);
          break;
        case "voornaamwoord":
        case "persoonlijk voornaamwoord":
          result.add(WordType.pronoun);
          break;
        case "lidwoord":
          result.add(WordType.article);
          break;
        case "voorzetsel":
          result.add(WordType.preposition);
          break;
        case "voegwoord":
          result.add(WordType.conjunction);
          break;
        case "tussenwerpsel":
          result.add(WordType.interjection);
          break;
        case "telwoord":
          result.add(WordType.numeral);
          break;
      }
    }

    return result;
  }
}
