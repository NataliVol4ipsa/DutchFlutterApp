import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class BaseWordDto {
  String? dutchWord;
  String? englishWord;
  WordType? wordType;
  DeHetType? deHetType;
  String? pluralForm;
  String? tag;
}
