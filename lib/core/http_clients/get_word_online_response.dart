import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';

class GetWordOnlineResponse {
  final String word;
  late WordType? partOfSpeech;
  late DeHetType? gender;
  late String? pluralForm;
  late String? diminutive;

  GetWordOnlineResponse(this.word);
}
