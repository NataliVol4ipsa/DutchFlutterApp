import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';

class ExportWordNounDetailsV1 {
  final DeHetType deHetType;
  final String? diminutive;
  final String? pluralForm;

  ExportWordNounDetailsV1(
      {this.deHetType = DeHetType.none, this.pluralForm, this.diminutive});

  ExportWordNounDetailsV1.fromDetails(WordNounDetails source)
      : deHetType = source.deHetType,
        pluralForm = source.pluralForm,
        diminutive = source.diminutive;

  ExportWordNounDetailsV1._fromJson(Map<String, dynamic> json)
      : deHetType =
            DeHetType.values.firstWhere((e) => e.toString() == json['deHet']),
        pluralForm = json['pluralForm'] as String?,
        diminutive = json['diminutive'] as String?;

  factory ExportWordNounDetailsV1.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) return ExportWordNounDetailsV1._empty();
    return ExportWordNounDetailsV1._fromJson(json);
  }

  ExportWordNounDetailsV1._empty()
      : deHetType = DeHetType.none,
        diminutive = null,
        pluralForm = null;

  Map<String, dynamic> toJson() => {
        'deHet': deHetType.toString(),
        'pluralForm': pluralForm,
        'diminutive': diminutive,
      };
}
