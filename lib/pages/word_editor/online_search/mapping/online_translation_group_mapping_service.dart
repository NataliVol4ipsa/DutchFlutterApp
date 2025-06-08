import 'package:collection/collection.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/gender_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_group.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/word_forms.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';

class OnlineTranslationGroupMappingService {
  static TranslationSearchResult? map(
      String searchedWord,
      OnlineTranslationGroup group,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    final String mainWord = _findMainWord(searchedWord, group);
    final remainingDutchWords = _filterRemainingWords(searchedWord, group);
    final examples = _mapExamples(group);
    final translationWords = _mapTranslationWords(group);
    final partOfSpeech = group.partOfSpeech;
    return TranslationSearchResult(
        mainWord: mainWord,
        synonyms: remainingDutchWords,
        translationWords: translationWords,
        partOfSpeech: partOfSpeech,
        sentenceExamples: examples,
        nounDetails: _findNounDetails(
            searchedWord, group, mainWord, partOfSpeech, grammarOptions),
        verbDetails:
            _findVerbDetails(partOfSpeech, group.wordForms?.grammarOption));
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
    if (group.partOfSpeech != PartOfSpeech.noun) return null;

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
    if (group.partOfSpeech != PartOfSpeech.noun) return null;

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

  static TranslationNounDetails? _findNounDetails(
      String searchedWord,
      OnlineTranslationGroup group,
      String mainWord,
      PartOfSpeech partOfSpeech,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    if (partOfSpeech != PartOfSpeech.noun || grammarOptions == null) {
      return null;
    }

    final article = _findArticle(searchedWord, mainWord, group);
    final gender = _findGender(searchedWord, mainWord, group);

    final pluralForm = _findFirstNonEmptyGrammarValue(
      grammarOptions,
      (d) => d.nounDetails.pluralForm,
    );

    final diminutive = _findFirstNonEmptyGrammarValue(
      grammarOptions,
      (d) => d.nounDetails.diminutive,
    );

    return TranslationNounDetails(
      gender: gender,
      article: article,
      pluralForm: pluralForm,
      diminutive: diminutive,
    );
  }

  static String? _findFirstNonEmptyGrammarValue(
    List<GetWordGrammarOnlineResponse> options,
    String? Function(GetWordGrammarOnlineResponse) extractor,
  ) {
    for (var option in options) {
      if (option.partOfSpeech == PartOfSpeech.noun) {
        final value = extractor(option);
        if (value != null && value.trim().isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }

  static TranslationVerbDetails? _findVerbDetails(
    PartOfSpeech partOfSpeech,
    GetWordGrammarOnlineResponse? grammarOption,
  ) {
    if (partOfSpeech != PartOfSpeech.verb || grammarOption == null) return null;

    final verb = grammarOption.verbDetails;

    return TranslationVerbDetails(
      infinitive: verb.infinitive,
      completedParticiple: verb.completedParticiple,
      auxiliaryVerb: verb.auxiliaryVerb,
      imperative: TranslationVerbImperativeDetails(
        informal: verb.imperative.informal,
        formal: verb.imperative.formal,
      ),
      presentParticiple: TranslationVerbPresentParticipleDetails(
        inflected: verb.presentParticiple.inflected,
        uninflected: verb.presentParticiple.uninflected,
      ),
      presentTense: TranslationVerbPresentTenseDetails(
        ik: verb.presentTense.ik,
        jijVraag: verb.presentTense.jijVraag,
        jij: verb.presentTense.jij,
        u: verb.presentTense.u,
        hijZijHet: verb.presentTense.hijZijHet,
        wij: verb.presentTense.wij,
        jullie: verb.presentTense.jullie,
        zij: verb.presentTense.zij,
      ),
      pastTense: TranslationVerbPastTenseDetails(
        ik: verb.pastTense.ik,
        jij: verb.pastTense.jij,
        hijZijHet: verb.pastTense.hijZijHet,
        wij: verb.pastTense.wij,
        jullie: verb.pastTense.jullie,
        zij: verb.pastTense.zij,
      ),
    );
  }
}
