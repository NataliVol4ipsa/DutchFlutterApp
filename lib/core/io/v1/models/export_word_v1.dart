import 'package:dutch_app/core/io/v1/models/export_word_noun_details_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_verb_details_v1.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class ExportWordV1 {
  final String? dutchWord;
  final List<String>? englishWords;
  final PartOfSpeech? partOfSpeech;
  final String? contextExample;
  final String? contextExampleTranslation;
  final String? userNote;
  final ExportWordNounDetailsV1? nounDetails;
  final ExportWordVerbDetailsV1? verbDetails;

  ExportWordV1(
    this.dutchWord,
    this.englishWords,
    this.partOfSpeech, {
    this.contextExample,
    this.contextExampleTranslation,
    this.userNote,
    this.nounDetails,
    this.verbDetails,
  });

  ExportWordV1.fromWord(Word source)
      : dutchWord = source.dutchWord,
        englishWords = source.englishWords,
        partOfSpeech = source.partOfSpeech,
        contextExample = source.contextExample,
        contextExampleTranslation = source.contextExampleTranslation,
        userNote = source.userNote,
        nounDetails = source.nounDetails != null
            ? ExportWordNounDetailsV1.fromDetails(source.nounDetails!)
            : null,
        verbDetails = source.verbDetails != null
            ? ExportWordVerbDetailsV1.fromDetails(source.verbDetails!)
            : null;

  ExportWordV1.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWords = List<String>.from(json['englishWords'] as List),
        partOfSpeech = PartOfSpeech.values
            .firstWhere((e) => e.toString() == json['partOfSpeech']),
        contextExample = json['contextExample'] as String?,
        contextExampleTranslation =
            json['contextExampleTranslation'] as String?,
        userNote = json['userNote'] as String?,
        nounDetails =
            ExportWordNounDetailsV1.fromNullableJson(json['nounDetails']),
        verbDetails =
            ExportWordVerbDetailsV1.fromNullableJson(json['verbDetails']);

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWords': englishWords,
        'partOfSpeech': partOfSpeech.toString(),
        'nounDetails': nounDetails?.toJson(),
        'verbDetails': verbDetails?.toJson(),
        'contextExample': contextExample,
        'contextExampleTranslation': contextExampleTranslation,
        'userNote': userNote,
      };
}
