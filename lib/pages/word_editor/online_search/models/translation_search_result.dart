import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/gender_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';

class TranslationSearchResult {
  final String mainWord;
  final List<String> synonyms;
  final List<SelectableString> translationWords;
  final PartOfSpeech? partOfSpeech;
  late List<TranslationSearchResultSentenceExample> sentenceExamples;
  late int translationScore;
  late TranslationNounDetails? nounDetails;
  late TranslationVerbDetails? verbDetails;
  TranslationSearchResult({
    required this.mainWord,
    required this.synonyms,
    required this.translationWords,
    required this.partOfSpeech,
    required this.nounDetails,
    required this.verbDetails,
    List<TranslationSearchResultSentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
    _evaluateTranslationScore();
  }

  void _evaluateTranslationScore() {
    translationScore = 0;
    translationScore += translationWords.isNotEmpty ? 10 : 0;
    translationScore += partOfSpeech != PartOfSpeech.unspecified ? 5 : 0;
    translationScore += sentenceExamples.isNotEmpty ? 2 : 0;
    translationScore += synonyms.isNotEmpty ? 1 : 0;
    translationScore +=
        nounDetails?.article != null && nounDetails!.article != DeHetType.none
            ? 3
            : 0;
    translationScore +=
        nounDetails?.gender != null && nounDetails!.gender != GenderType.none
            ? 3
            : 0;
  }
}

class TranslationNounDetails {
  final GenderType? gender;
  final DeHetType? article;
  final String? pluralForm;
  final String? diminutive;
  TranslationNounDetails(
      {this.gender, this.article, this.pluralForm, this.diminutive});
}

class TranslationVerbDetails {
  final String? infinitive;
  final String? completedParticiple;
  final String? auxiliaryVerb;

  final TranslationVerbImperativeDetails imperative;
  final TranslationVerbPresentParticipleDetails presentParticiple;
  final TranslationVerbPresentTenseDetails presentTense;
  final TranslationVerbPastTenseDetails pastTense;

  TranslationVerbDetails({
    this.infinitive,
    this.completedParticiple,
    this.auxiliaryVerb,
    required this.imperative,
    required this.presentParticiple,
    required this.presentTense,
    required this.pastTense,
  });
}

class TranslationVerbImperativeDetails {
  final String? informal;
  final String? formal;

  TranslationVerbImperativeDetails({this.informal, this.formal});
}

class TranslationVerbPresentParticipleDetails {
  final String? inflected;
  final String? uninflected;

  TranslationVerbPresentParticipleDetails({this.inflected, this.uninflected});
}

class TranslationVerbPresentTenseDetails {
  final String? ik;
  final String? jijVraag;
  final String? jij;
  final String? u;
  final String? hijZijHet;
  final String? wij;
  final String? jullie;
  final String? zij;

  TranslationVerbPresentTenseDetails({
    this.ik,
    this.jijVraag,
    this.jij,
    this.u,
    this.hijZijHet,
    this.wij,
    this.jullie,
    this.zij,
  });
}

class TranslationVerbPastTenseDetails {
  final String? ik;
  final String? jij;
  final String? hijZijHet;
  final String? wij;
  final String? jullie;
  final String? zij;

  TranslationVerbPastTenseDetails({
    this.ik,
    this.jij,
    this.hijZijHet,
    this.wij,
    this.jullie,
    this.zij,
  });
}
