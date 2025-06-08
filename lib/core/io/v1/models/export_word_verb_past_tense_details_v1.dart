import 'package:dutch_app/domain/models/verb_details/word_verb_past_tense_details.dart';

class ExportWordVerbPastTenseDetailsV1 {
  final String? ik;
  final String? jij;
  final String? hijZijHet;
  final String? wij;
  final String? jullie;
  final String? zij;

  ExportWordVerbPastTenseDetailsV1({
    this.ik,
    this.jij,
    this.hijZijHet,
    this.wij,
    this.jullie,
    this.zij,
  });

  ExportWordVerbPastTenseDetailsV1.fromDetails(WordVerbPastTenseDetails source)
      : ik = source.ik,
        jij = source.jij,
        hijZijHet = source.hijZijHet,
        wij = source.wij,
        jullie = source.jullie,
        zij = source.zij;

  ExportWordVerbPastTenseDetailsV1.fromJson(Map<String, dynamic> json)
      : ik = json['ik'],
        jij = json['jij'],
        hijZijHet = json['hijZijHet'],
        wij = json['wij'],
        jullie = json['jullie'],
        zij = json['zij'];

  ExportWordVerbPastTenseDetailsV1.empty()
      : ik = null,
        jij = null,
        hijZijHet = null,
        wij = null,
        jullie = null,
        zij = null;

  Map<String, dynamic> toJson() => {
        'ik': ik,
        'jij': jij,
        'hijZijHet': hijZijHet,
        'wij': wij,
        'jullie': jullie,
        'zij': zij,
      };
}
