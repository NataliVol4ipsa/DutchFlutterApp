import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class GetWordOnlineResponse {
  final String word;
  late WordType? partOfSpeech;
  late DeHetType? gender;
  late String? pluralForm;
  late String? diminutive;
  late String? note;

  GetWordOnlineResponse(this.word);
}
