import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_search_response.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_words_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_group_mapping_service.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_groupping_service.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translations_search_result.dart';

/*
test cases:
meisjes -> group meisje
zitten -> group zit
*/
class OnlineTranslationListMappingService {
  static TranslationsSearchResult? mapToResult(
      DutchToEnglishSearchResponse? response,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    if (response == null) {
      return null;
    }

    return TranslationsSearchResult(
        _mapTranslations(response.searchedWord.toLowerCase(),
            response.translations, grammarOptions),
        sentenceExamples: _mapExamples(response.sentenceExamples));
  }

  // Entire list of translations
  static List<TranslationSearchResult> _mapTranslations(
      String searchedWord,
      List<DutchToEnglishTranslation> translationOptions,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    var grouppedTranslations = OnlineTranslationGrouppingService.group(
        searchedWord, translationOptions, grammarOptions);

    List<TranslationSearchResult> mappedTranslations = grouppedTranslations
        .map((group) =>
            OnlineTranslationGroupMappingService.map(searchedWord, group))
        .whereType<TranslationSearchResult>()
        .toList();

    return mappedTranslations;
  }

  //todo use or remove
  static List<TranslationSearchResultSentenceExample> _mapExamples(
      List<SentenceExample> onlineExamples) {
    return onlineExamples
        .map((e) => TranslationSearchResultSentenceExample(
            e.dutchSentence, e.englishSentence, true))
        .toList();
  }

  static String? findNounPluralForm(WordType translationWordType,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    if (translationWordType != WordType.noun || grammarOptions == null) {
      return null;
    }

    for (var option in grammarOptions) {
      if (option.partOfSpeech == WordType.noun &&
          option.nounDetails.pluralForm != null &&
          option.nounDetails.pluralForm!.trim().isNotEmpty) {
        return option.nounDetails.pluralForm;
      }
    }

    return null;
  }
}
