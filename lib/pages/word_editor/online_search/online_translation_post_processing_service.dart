import 'package:collection/collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_search_response.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translations_search_result.dart';

class OnlineTranslationPostProcessingService {
  static TranslationsSearchResult? mapToResult(
      DutchToEnglishSearchResponse? response) {
    if (response == null) {
      return null;
    }

    return TranslationsSearchResult(
        _mapTranslations(response.translations, response.searchedWord),
        sentenceExamples: _mapExamples(response.sentenceExamples));
  }

  // Entire list of translations
  static List<TranslationSearchResult> _mapTranslations(
      List<DutchToEnglishTranslation> onlineResults, String searchedWord) {
    List<TranslationSearchResult> mappedTranslations = onlineResults
        .map((onlineResult) => _mapTranslation(onlineResult, searchedWord))
        .whereType<TranslationSearchResult>()
        .toList();

    mappedTranslations
        .sort((a, b) => b.translationScore.compareTo(a.translationScore));

    return mappedTranslations;
  }

  // Whole translation: word, synonyms, translations, examples
  static TranslationSearchResult? _mapTranslation(
      DutchToEnglishTranslation onlineResult, String searchedWord) {
    if (onlineResult.dutchWords.isEmpty) return null;
    final mainWord = _findMainWord(onlineResult.dutchWords, searchedWord);
    final remainingDutchWords =
        onlineResult.dutchWords.where((w) => w != mainWord).toList();
    final article = _defineArticle(mainWord.article, mainWord.gender);
    final examples = _mapExamples(onlineResult.sentenceExamples);

    return TranslationSearchResult(
        mainWord: mainWord.word,
        synonyms: remainingDutchWords.map((w) => w.word).toList(),
        translationWords: onlineResult.englishWords,
        partOfSpeech: onlineResult.partsOfSpeech.firstOrNull,
        article: article,
        gender: mainWord.gender,
        sentenceExamples: examples);
  }

  static DeHetType? _defineArticle(
      DeHetType? onlineArticle, GenderType? onlineGender) {
    if (onlineArticle != null && onlineArticle != DeHetType.none) {
      return onlineArticle;
    }

    if (onlineGender != null && onlineGender != GenderType.none) {
      if (onlineGender == GenderType.onzijdig) {
        return DeHetType.het;
      } else {
        return DeHetType.de;
      }
    }

    return onlineArticle;
  }

  static OnlineTranslationDutchWord _findMainWord(
      List<OnlineTranslationDutchWord> dutchWords, String searchedWord) {
    //todo improve search by looking at infinitive for verb and some base form of adjective. Check all word types
    final lowerOriginal = searchedWord.toLowerCase();

    OnlineTranslationDutchWord? mainWord = dutchWords
        .firstWhereOrNull((w) => w.word.toLowerCase() == lowerOriginal);

    mainWord ??= dutchWords
        .firstWhereOrNull((w) => w.word.toLowerCase().contains(lowerOriginal));

    mainWord ??= dutchWords.first;

    return mainWord;
  }

  static List<TranslationSearchResultSentenceExample> _mapExamples(
      List<SentenceExample> onlineExamples) {
    return onlineExamples
        .map((e) => TranslationSearchResultSentenceExample(
            e.dutchSentence, e.englishSentence))
        .toList();
  }

  static String? findNounPluralForm(WordType translationWordType,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    if (translationWordType != WordType.noun || grammarOptions == null) {
      return null;
    }

    for (var option in grammarOptions) {
      if (option.partOfSpeech == WordType.noun &&
          option.pluralForm != null &&
          option.pluralForm!.trim().isNotEmpty) {
        return option.pluralForm;
      }
    }

    return null;
  }
}

/*
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

      DeHetType? entireTranslationArticle =
          _processEntireTranslationArticle(dutchWords, originalWord);

      if (dutchWords.isNotEmpty && englishWords.isNotEmpty) {
        final lowerOriginal = originalWord.toLowerCase();
        OnlineTranslationDutchWord? mainWord = dutchWords
            .firstWhereOrNull((w) => w.word.toLowerCase() == lowerOriginal);
        mainWord ??= dutchWords.firstWhereOrNull(
            (w) => w.word.toLowerCase().contains(lowerOriginal));
        mainWord ??= dutchWords.first;

        final remainingDutchWords =
            dutchWords.where((w) => w != mainWord).toList();

        translationResults.add(
          DutchToEnglishTranslation(remainingDutchWords, englishWords,
              partsOfSpeech, entireTranslationArticle,
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
        article = _processArticle(articleText, gender);
      }

      dutchWords.add(
          OnlineTranslationDutchWord(word, gender: gender, article: article));
    }
    return dutchWords;
  }

  DeHetType? _processArticle(String? articleText, GenderType? gender) {
    var article = articleText == '(het ~)'
        ? DeHetType.het
        : articleText == '(de ~)'
            ? DeHetType.de
            : DeHetType.none;

    if (article == DeHetType.none &&
        gender != null &&
        gender != GenderType.none) {
      if (gender == GenderType.onzijdig) {
        article = DeHetType.het;
      } else {
        article = DeHetType.de;
      }
    }

    return article;
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

  DeHetType? _processEntireTranslationArticle(
      List<OnlineTranslationDutchWord> dutchWords, String originalWord) {
    if (dutchWords.isEmpty) return null;

    var originalLower = originalWord.toLowerCase();

    return dutchWords
        .firstWhereOrNull((w) => w.word.toLowerCase() == originalLower)
        ?.article;
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
*/
