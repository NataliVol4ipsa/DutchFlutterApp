import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';

class ExportWordV1 {
  String? dutchWord;
  List<String>? englishWords;
  WordType? wordType;
  DeHetType? deHetType = DeHetType.none;
  String? pluralForm;
  String? contextExample;
  String? contextExampleTranslation;
  String? userNote;

  ExportWordV1(
    this.dutchWord,
    this.englishWords,
    this.wordType, {
    this.deHetType = DeHetType.none,
    this.pluralForm,
    this.contextExample,
    this.contextExampleTranslation,
    this.userNote,
  });

  ExportWordV1.fromWord(Word source)
      : dutchWord = source.dutchWord,
        englishWords = source.englishWords,
        wordType = source.wordType,
        deHetType = source.deHetType,
        pluralForm = source.pluralForm,
        contextExample = source.contextExample,
        contextExampleTranslation = source.contextExampleTranslation,
        userNote = source.userNote;

  ExportWordV1.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWords = List<String>.from(json['englishWords'] as List),
        wordType =
            WordType.values.firstWhere((e) => e.toString() == json['type']),
        deHetType =
            DeHetType.values.firstWhere((e) => e.toString() == json['deHet']),
        pluralForm = json['pluralForm'] as String?,
        contextExample = json['contextExample'] as String?,
        contextExampleTranslation =
            json['contextExampleTranslation'] as String?,
        userNote = json['userNote'] as String?;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWords': englishWords,
        'type': wordType.toString(),
        'deHet': deHetType.toString(),
        'pluralForm': pluralForm,
        'contextExample': contextExample,
        'contextExampleTranslation': contextExampleTranslation,
        'userNote': userNote,
      };
}
