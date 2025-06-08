import 'package:dutch_app/core/io/v1/models/export_word_verb_imperative_details_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_verb_past_tense_details_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_verb_present_participle_details_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_verb_present_tense_details_v1.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_details.dart';

class ExportWordVerbDetailsV1 {
  final String? infinitive;
  final String? completedParticiple;
  final String? auxiliaryVerb;

  final ExportWordVerbImperativeDetailsV1 imperative;
  final ExportWordVerbPresentParticipleDetailsV1 presentParticiple;
  final ExportWordVerbPresentTenseDetailsV1 presentTense;
  final ExportWordVerbPastTenseDetailsV1 pastTense;

  ExportWordVerbDetailsV1({
    this.infinitive,
    this.completedParticiple,
    this.auxiliaryVerb,
    required this.imperative,
    required this.presentParticiple,
    required this.presentTense,
    required this.pastTense,
  });

  ExportWordVerbDetailsV1.fromDetails(WordVerbDetails source)
      : infinitive = source.infinitive,
        completedParticiple = source.completedParticiple,
        auxiliaryVerb = source.auxiliaryVerb,
        imperative =
            ExportWordVerbImperativeDetailsV1.fromDetails(source.imperative),
        presentParticiple =
            ExportWordVerbPresentParticipleDetailsV1.fromDetails(
                source.presentParticiple),
        presentTense = ExportWordVerbPresentTenseDetailsV1.fromDetails(
            source.presentTense),
        pastTense =
            ExportWordVerbPastTenseDetailsV1.fromDetails(source.pastTense);

  ExportWordVerbDetailsV1._fromJson(Map<String, dynamic> json)
      : infinitive = json['infinitive'] as String?,
        completedParticiple = json['completedParticiple'] as String?,
        auxiliaryVerb = json['auxiliaryVerb'] as String?,
        imperative =
            ExportWordVerbImperativeDetailsV1.fromJson(json['imperative']),
        presentParticiple = ExportWordVerbPresentParticipleDetailsV1.fromJson(
            json['presentParticiple']),
        presentTense =
            ExportWordVerbPresentTenseDetailsV1.fromJson(json['presentTense']),
        pastTense =
            ExportWordVerbPastTenseDetailsV1.fromJson(json['pastTense']);

  factory ExportWordVerbDetailsV1.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) return ExportWordVerbDetailsV1._empty();
    return ExportWordVerbDetailsV1._fromJson(json);
  }

  ExportWordVerbDetailsV1._empty()
      : infinitive = null,
        completedParticiple = null,
        auxiliaryVerb = null,
        imperative = ExportWordVerbImperativeDetailsV1.empty(),
        presentParticiple = ExportWordVerbPresentParticipleDetailsV1.empty(),
        presentTense = ExportWordVerbPresentTenseDetailsV1.empty(),
        pastTense = ExportWordVerbPastTenseDetailsV1.empty();

  Map<String, dynamic> toJson() => {
        'infinitive': infinitive,
        'completedParticiple': completedParticiple,
        'auxiliaryVerb': auxiliaryVerb,
        'imperative': imperative.toJson(),
        'presentParticiple': presentParticiple.toJson(),
        'presentTense': presentTense.toJson(),
        'pastTense': pastTense.toJson(),
      };
}
