import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class GetWordGrammarOnlineResponse {
  final String word;
  late WordType? partOfSpeech;
  late DeHetType? gender;
  late String? pluralForm;
  late String? infinitive;
  late String? diminutive;
  late String? note;

  GetWordGrammarOnlineResponse(this.word);
}
