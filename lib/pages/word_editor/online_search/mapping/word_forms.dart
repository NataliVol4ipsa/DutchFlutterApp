import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/gender_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';

class WordForms {
  late PartOfSpeech partOfSpeech;
  late Set<String> values;
  late GetWordGrammarOnlineResponse grammarOption;
  WordForms({required String searchedWord, required this.grammarOption}) {
    partOfSpeech = grammarOption.partOfSpeech!;
    values = [
      searchedWord,
      grammarOption.word,
      grammarOption.nounDetails.diminutive,
      grammarOption.nounDetails.pluralForm,
      grammarOption.verbDetails.infinitive,
      grammarOption.verbDetails.completedParticiple,
      grammarOption.verbDetails.auxiliaryVerb,
      grammarOption.verbDetails.imperative.formal,
      grammarOption.verbDetails.imperative.informal,
      grammarOption.verbDetails.presentParticiple.uninflected,
      grammarOption.verbDetails.presentParticiple.inflected,
      grammarOption.verbDetails.presentTense.ik,
      grammarOption.verbDetails.presentTense.jijVraag,
      grammarOption.verbDetails.presentTense.jij,
      grammarOption.verbDetails.presentTense.u,
      grammarOption.verbDetails.presentTense.hijZijHet,
      grammarOption.verbDetails.presentTense.wij,
      grammarOption.verbDetails.presentTense.jullie,
      grammarOption.verbDetails.presentTense.zij,
      grammarOption.verbDetails.pastTense.ik,
      grammarOption.verbDetails.pastTense.jij,
      grammarOption.verbDetails.pastTense.hijZijHet,
      grammarOption.verbDetails.pastTense.wij,
      grammarOption.verbDetails.pastTense.jullie,
      grammarOption.verbDetails.pastTense.zij,
    ].whereType<String>().map((w) => w.toLowerCase()).toSet();
  }

  bool isFormOf(DutchToEnglishTranslation translation) =>
      translation.partOfSpeech == partOfSpeech &&
      translation.dutchWords.any((item) =>
          _isMatchingArticle(item) && values.contains(item.word.toLowerCase()));

  bool _isMatchingArticle(OnlineTranslationDutchWord word) {
    if (partOfSpeech != PartOfSpeech.noun) return true;
    if (word.article != null && word.article != DeHetType.none) {
      return word.article == grammarOption.nounDetails.gender;
    }

    if (word.gender == GenderType.mannelijk ||
        word.gender == GenderType.vrouwelijk) {
      return grammarOption.nounDetails.gender == DeHetType.de;
    }

    if (word.gender == GenderType.onzijdig) {
      return grammarOption.nounDetails.gender == DeHetType.het;
    }

    return true;
  }
}
