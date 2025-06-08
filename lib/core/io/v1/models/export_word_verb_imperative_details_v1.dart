import 'package:dutch_app/domain/models/verb_details/word_verb_imperative_details.dart';

class ExportWordVerbImperativeDetailsV1 {
  final String? informal;
  final String? formal;

  ExportWordVerbImperativeDetailsV1({this.informal, this.formal});

  ExportWordVerbImperativeDetailsV1.fromDetails(
      WordVerbImperativeDetails source)
      : informal = source.informal,
        formal = source.formal;

  ExportWordVerbImperativeDetailsV1.fromJson(Map<String, dynamic> json)
      : informal = json['informal'],
        formal = json['formal'];

  ExportWordVerbImperativeDetailsV1.empty()
      : informal = null,
        formal = null;

  Map<String, dynamic> toJson() => {
        'informal': informal,
        'formal': formal,
      };
}
