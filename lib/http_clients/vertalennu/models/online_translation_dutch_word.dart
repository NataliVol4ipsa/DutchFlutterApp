import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';

class OnlineTranslationDutchWord {
  String word;
  GenderType? gender;
  DeHetType? article;
  OnlineTranslationDutchWord(this.word, {this.gender, this.article});
}
