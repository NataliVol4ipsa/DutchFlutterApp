import 'package:collection/collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_search_response.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_grammar_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_words_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translations_search_result.dart';

class OnlineTranslationPostProcessingService {
  static TranslationsSearchResult? mapToResult(
      DutchToEnglishSearchResponse? response,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    if (response == null) {
      return null;
    }

    return TranslationsSearchResult(
        _mapTranslations(
            response.translations, response.searchedWord, grammarOptions),
        sentenceExamples: _mapExamples(response.sentenceExamples));
  }

  // Entire list of translations
  static List<TranslationSearchResult> _mapTranslations(
      List<DutchToEnglishTranslation> onlineResults,
      String searchedWord,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    List<TranslationSearchResult> mappedTranslations = onlineResults
        .map((onlineResult) =>
            _mapTranslation(onlineResult, searchedWord, grammarOptions))
        .whereType<TranslationSearchResult>()
        .toList();

    mappedTranslations
        .sort((a, b) => b.translationScore.compareTo(a.translationScore));

    final grouppedTranslations = _groupTranslations(mappedTranslations);

    return grouppedTranslations;
  }

  // Whole translation: word, synonyms, translations, examples
  static TranslationSearchResult? _mapTranslation(
      DutchToEnglishTranslation onlineResult,
      String searchedWord,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    if (onlineResult.dutchWords.isEmpty) return null;
    final mainWord =
        _findMainWord(onlineResult.dutchWords, searchedWord, grammarOptions);
    final remainingDutchWords =
        onlineResult.dutchWords.where((w) => w != mainWord).toList();
    final article = _defineArticle(mainWord.article, mainWord.gender);
    final examples = _mapExamples(onlineResult.sentenceExamples);
    final translationWords = onlineResult.englishWords
        .map((w) => SelectableString(value: w))
        .toList();

    return TranslationSearchResult(
        mainWord: mainWord.word,
        synonyms: remainingDutchWords.map((w) => w.word).toList(),
        translationWords: translationWords,
        partOfSpeech: onlineResult.partsOfSpeech.firstOrNull,
        article: article,
        gender: mainWord.gender,
        sentenceExamples: examples);
  }

  // Works with sorted translations
  static List<TranslationSearchResult> _groupTranslations(
      List<TranslationSearchResult> mappedTranslations) {
    final Map<String, List<TranslationSearchResult>> groupped = {};

    for (var result in mappedTranslations) {
      final key = '${result.mainWord}_${result.partOfSpeech}';
      groupped.putIfAbsent(key, () => []).add(result);
    }

    final mergedTranslations =
        groupped.values.map((value) => _mergeTranslations(value)).toList();
    return mergedTranslations;
  }

  // Works with sorted translations because first has to contain all info
  static TranslationSearchResult _mergeTranslations(
      List<TranslationSearchResult> mappedTranslations) {
    final first = mappedTranslations.first;
    final mergedSynonyms =
        mappedTranslations.expand((e) => e.synonyms).toSet().toList();
    final mergedTranslations = mappedTranslations
        .expand((e) => e.translationWords)
        .fold<Map<String, SelectableString>>({}, (map, item) {
          map[item.value] ??= item;
          return map;
        })
        .values
        .toList();
    final mergedSentenceExamples = {
      for (var e in mappedTranslations.expand((r) => r.sentenceExamples))
        e.dutchSentence.toLowerCase(): e
    }.values.toList();

    return TranslationSearchResult(
        mainWord: first.mainWord,
        gender: first.gender,
        article: first.article,
        partOfSpeech: first.partOfSpeech,
        synonyms: mergedSynonyms,
        translationWords: mergedTranslations,
        sentenceExamples: mergedSentenceExamples);
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
      List<OnlineTranslationDutchWord> dutchWords,
      String searchedWord,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    final lowerOriginal = searchedWord.toLowerCase();

    OnlineTranslationDutchWord? mainWord = dutchWords
        .firstWhereOrNull((w) => w.word.toLowerCase() == lowerOriginal);

    mainWord ??= dutchWords
        .firstWhereOrNull((w) => w.word.toLowerCase().contains(lowerOriginal));

    mainWord ??=
        _findInfinitiveMainWord(dutchWords, searchedWord, grammarOptions);

    mainWord ??= dutchWords.first;

    return mainWord;
  }

  static OnlineTranslationDutchWord? _findInfinitiveMainWord(
      List<OnlineTranslationDutchWord> dutchWords,
      String searchedWord,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    final infinitive = grammarOptions?.onlineWords
        .firstWhereOrNull(
            (w) => w.partOfSpeech == WordType.verb && w.infinitive != null)
        ?.infinitive;

    if (infinitive == null) return null;
    final lowerInfinitive = infinitive.toLowerCase();

    return dutchWords
            .firstWhereOrNull((w) => w.word.toLowerCase() == lowerInfinitive) ??
        dutchWords.firstWhereOrNull(
            (w) => w.word.toLowerCase().contains(lowerInfinitive));
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
