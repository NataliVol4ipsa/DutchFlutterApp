import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';

class Word {
  final String dutchWord;
  final String englishWord;
  final WordType type;
  DeHetType deHet = DeHetType.none;
  String? pluralForm;
  String? tag;

  Word(
    this.dutchWord,
    this.englishWord,
    this.type, {
    this.deHet = DeHetType.none,
    this.pluralForm,
    this.tag,
  });
  Word.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWord = json['englishWord'] as String,
        type = json['type'] as WordType,
        deHet = json['deHet'] as DeHetType,
        pluralForm = json['pluralForm'] as String,
        tag = json['tag'] as String;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWord': englishWord,
        'type': type,
        'deHet': deHet,
        'pluralForm': pluralForm,
        'tag': tag,
      };
}

class WordList {}
