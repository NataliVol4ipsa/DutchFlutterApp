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
  TranslationVerbDetails({this.infinitive});
}
