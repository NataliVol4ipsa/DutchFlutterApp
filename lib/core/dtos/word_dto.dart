import 'package:first_project/core/models/base_word.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';

class WordDto implements BaseWord {
  @override
  String? dutchWord;
  @override
  String? englishWord;
  @override
  WordType? wordType;
  @override
  DeHetType? deHetType = DeHetType.none;
  @override
  String? pluralForm;
  @override
  String? tag;

  WordDto(
    this.dutchWord,
    this.englishWord,
    this.wordType, {
    this.deHetType = DeHetType.none,
    this.pluralForm,
    this.tag,
  });

  WordDto.fromWord(Word source)
      : dutchWord = source.dutchWord,
        englishWord = source.englishWord,
        wordType = source.wordType,
        deHetType = source.deHetType,
        pluralForm = source.pluralForm,
        tag = source.tag;

  WordDto.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWord = json['englishWord'] as String,
        wordType = json['type'] as WordType,
        deHetType = json['deHet'] as DeHetType,
        pluralForm = json['pluralForm'] as String,
        tag = json['tag'] as String;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWord': englishWord,
        'type': wordType.toString(),
        'deHet': deHetType.toString(),
        'pluralForm': pluralForm,
        'tag': tag,
      };
}