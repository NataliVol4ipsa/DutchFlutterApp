import 'package:dutch_app/domain/types/part_of_speech.dart';

class WordTypeConverter {
  static PartOfSpeech toWordType(String woordenlijstPartOfSpeechCode) {
    switch (woordenlijstPartOfSpeechCode) {
      case "AA":
        return PartOfSpeech.adjective;
      case "ADV":
        return PartOfSpeech.adverb;
      case "ADP":
        return PartOfSpeech.preposition;
      case "NOU-C":
      case "NOU-P":
        return PartOfSpeech.noun;
      case "INT":
        return PartOfSpeech.interjection;
      case "CONJ":
        return PartOfSpeech.conjunction;
      case "COLL":
        return PartOfSpeech.fixedConjunction;
      case "PD":
        return PartOfSpeech.pronoun;
      case "NUM":
        return PartOfSpeech.numeral;
      case "VRB":
        return PartOfSpeech.verb;
      case "RES":
      default:
        return PartOfSpeech.unspecified;
    }
  }

  static String? toPartOfSpeechCode(PartOfSpeech? wordType) {
    if (wordType == null) {
      return null;
    }

    switch (wordType) {
      case PartOfSpeech.adjective:
        return "AA";
      case PartOfSpeech.adverb:
        return "ADV";
      case PartOfSpeech.preposition:
        return "ADP";
      case PartOfSpeech.noun:
        return "NOU-C|NOU-P";
      case PartOfSpeech.interjection:
        return "INT";
      case PartOfSpeech.conjunction:
        return "CONJ";
      case PartOfSpeech.fixedConjunction:
        return "COLL";
      case PartOfSpeech.pronoun:
        return "PD";
      case PartOfSpeech.numeral:
        return "NUM";
      case PartOfSpeech.verb:
        return "VRB";
      case PartOfSpeech.unspecified:
      default:
        return null;
    }
  }
}
