import 'package:dutch_app/domain/models/verb_details/word_verb_present_participle_details.dart';

class ExportWordVerbPresentParticipleDetailsV1 {
  final String? inflected;
  final String? uninflected;

  ExportWordVerbPresentParticipleDetailsV1({this.inflected, this.uninflected});

  ExportWordVerbPresentParticipleDetailsV1.fromDetails(
      WordVerbPresentParticipleDetails source)
      : inflected = source.inflected,
        uninflected = source.uninflected;

  ExportWordVerbPresentParticipleDetailsV1.fromJson(Map<String, dynamic> json)
      : inflected = json['inflected'],
        uninflected = json['uninflected'];

  ExportWordVerbPresentParticipleDetailsV1.empty()
      : inflected = null,
        uninflected = null;

  Map<String, dynamic> toJson() => {
        'inflected': inflected,
        'uninflected': uninflected,
      };
}
