import 'package:dutch_app/domain/models/verb_details/word_verb_present_tense_details.dart';

class ExportWordVerbPresentTenseDetailsV1 {
  final String? ik;
  final String? jijVraag;
  final String? jij;
  final String? u;
  final String? hijZijHet;
  final String? wij;
  final String? jullie;
  final String? zij;

  ExportWordVerbPresentTenseDetailsV1({
    this.ik,
    this.jijVraag,
    this.jij,
    this.u,
    this.hijZijHet,
    this.wij,
    this.jullie,
    this.zij,
  });

  ExportWordVerbPresentTenseDetailsV1.fromDetails(
      WordVerbPresentTenseDetails source)
      : ik = source.ik,
        jijVraag = source.jijVraag,
        jij = source.jij,
        u = source.u,
        hijZijHet = source.hijZijHet,
        wij = source.wij,
        jullie = source.jullie,
        zij = source.zij;

  ExportWordVerbPresentTenseDetailsV1.fromJson(Map<String, dynamic> json)
      : ik = json['ik'],
        jijVraag = json['jijVraag'],
        jij = json['jij'],
        u = json['u'],
        hijZijHet = json['hijZijHet'],
        wij = json['wij'],
        jullie = json['jullie'],
        zij = json['zij'];

  ExportWordVerbPresentTenseDetailsV1.empty()
      : ik = null,
        jijVraag = null,
        jij = null,
        u = null,
        hijZijHet = null,
        wij = null,
        jullie = null,
        zij = null;

  Map<String, dynamic> toJson() => {
        'ik': ik,
        'jijVraag': jijVraag,
        'jij': jij,
        'u': u,
        'hijZijHet': hijZijHet,
        'wij': wij,
        'jullie': jullie,
        'zij': zij,
      };
}
