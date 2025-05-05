import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/gender_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';

class TranslationSearchResult {
  final String mainWord;
  final List<String> synonyms;
  final GenderType? gender;
  final DeHetType? article;
  final List<SelectableString> translationWords;
  final WordType? partOfSpeech;
  late List<TranslationSearchResultSentenceExample> sentenceExamples;
  late int translationScore;
  late VerbDetails verbDetails;
  TranslationSearchResult({
    required this.mainWord,
    required this.synonyms,
    required this.translationWords,
    required this.partOfSpeech,
    required this.article,
    required this.gender,
    String? infinitive,
    List<TranslationSearchResultSentenceExample>? sentenceExamples,
  }) {
    this.sentenceExamples = sentenceExamples ?? [];
    verbDetails = VerbDetails();
    verbDetails.infinitive = infinitive;
    _evaluateTranslationScore();
  }

  void _evaluateTranslationScore() {
    translationScore = 0;
    translationScore += translationWords.isNotEmpty ? 10 : 0;
    translationScore += partOfSpeech != WordType.unspecified ? 5 : 0;
    translationScore += article != null && article != DeHetType.none ? 3 : 0;
    translationScore += gender != null && gender != GenderType.none ? 3 : 0;
    translationScore += sentenceExamples.isNotEmpty ? 2 : 0;
    translationScore += synonyms.isNotEmpty ? 1 : 0;
  }
}

class VerbDetails {
  late String? infinitive;
  VerbDetails();
}
