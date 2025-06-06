import 'package:dutch_app/domain/types/de_het_type.dart';

class WordNounDetails {
  final DeHetType deHetType;
  final String? diminutive;
  final String? pluralForm;

  WordNounDetails(
      {this.deHetType = DeHetType.none, this.pluralForm, this.diminutive});
}
