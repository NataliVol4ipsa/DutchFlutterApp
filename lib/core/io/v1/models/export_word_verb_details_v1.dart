import 'package:dutch_app/domain/models/word_verb_details.dart';

class ExportWordVerbDetailsV1 {
  ExportWordVerbDetailsV1.fromDetails(WordVerbDetails source);

  ExportWordVerbDetailsV1._fromJson(Map<String, dynamic> json);

  factory ExportWordVerbDetailsV1.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) return ExportWordVerbDetailsV1._empty();
    return ExportWordVerbDetailsV1._fromJson(json);
  }

  ExportWordVerbDetailsV1._empty();

  Map<String, dynamic> toJson() => {};
}
