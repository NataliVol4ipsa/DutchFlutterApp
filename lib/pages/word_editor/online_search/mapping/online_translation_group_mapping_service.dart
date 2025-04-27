import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_group.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/word_forms.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';

class OnlineTranslationGroupMappingService {
  static TranslationSearchResult? map(
      String searchedWord, OnlineTranslationGroup group) {
    final String mainWord = _findMainWord(searchedWord, group);
    final remainingDutchWords = _filterRemainingWords(searchedWord, group);
    final article = _findArticle(searchedWord, mainWord, group);
    final gender = _findGender(searchedWord, mainWord, group);
    final examples = _mapExamples(group);
    final translationWords = _mapTranslationWords(group);
    final partOfSpeech = group.partOfSpeech;
    return TranslationSearchResult(
        mainWord: mainWord,
        synonyms: remainingDutchWords,
        translationWords: translationWords,
        partOfSpeech: partOfSpeech,
        article: article,
        gender: gender,
        sentenceExamples: examples);
  }

  static String _findMainWord(
      String searchedWord, OnlineTranslationGroup group) {
    var result = group.wordForms?.grammarOption.word;
    result ??= group.values.firstOrNull?.dutchWords.firstOrNull?.word;
    result ??= searchedWord;
    return result;
  }

  static List<String> _filterRemainingWords(
      String searchedWord, OnlineTranslationGroup group) {
    return group.values
        .expand((t) => t.dutchWords)
        .map((w) => w.word)
        .toSet()
        .where((w) =>
            w != searchedWord &&
            !(group.wordForms?.values.contains(w) ?? false))
        .toList();
  }

  //todo get from woordenlijst instead?
  static GenderType? _findGender(
      String searchedWord, String mainWord, OnlineTranslationGroup group) {
    if (group.partOfSpeech != WordType.noun) return null;

    for (var translation in group.values) {
      for (var dutch in translation.dutchWords) {
        if (dutch.word == mainWord || dutch.word == searchedWord) {
          if (dutch.gender != null && dutch.gender != GenderType.none) {
            return dutch.gender;
          }
        }
      }
    }

    return null;
  }

  static DeHetType? _findArticle(
      String searchedWord, String mainWord, OnlineTranslationGroup group) {
    if (group.partOfSpeech != WordType.noun) return null;

    var article = group.wordForms?.grammarOption.nounDetails.gender;
    if (article != null) {
      return article;
    }

    for (var translation in group.values) {
      for (var dutch in translation.dutchWords) {
        if (dutch.word == mainWord || dutch.word == searchedWord) {
          if (dutch.article != null && dutch.article != DeHetType.none) {
            return dutch.article;
          }
          if (dutch.gender != null && dutch.gender != GenderType.none) {
            if (dutch.gender == GenderType.onzijdig) {
              return DeHetType.het;
            } else {
              return DeHetType.de;
            }
          }
        }
      }
    }

    return null;
  }

  static List<TranslationSearchResultSentenceExample> _mapExamples(
      OnlineTranslationGroup group) {
    var result = group.values
        .expand((t) => t.sentenceExamples)
        .map((e) => TranslationSearchResultSentenceExample(e.dutchSentence,
            e.englishSentence, _isRelevantSentenceExample(e, group.wordForms)))
        .toList();

    result.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return result;
  }

  static bool _isRelevantSentenceExample(
      SentenceExample sentenceExample, WordForms? wordForms) {
    if (wordForms == null) return true;

    return wordForms.values
        .any((wordForm) => sentenceExample.dutchSentence.contains(wordForm));
  }

  static List<SelectableString> _mapTranslationWords(
      OnlineTranslationGroup group) {
    return group.values
        .expand((e) => e.englishWords)
        .toSet()
        .map((w) => SelectableString(value: w))
        .toList();
  }
}
