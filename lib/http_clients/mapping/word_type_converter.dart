import 'package:first_project/core/types/word_type.dart';

class WordTypeConverter {
  static WordType toWordType(String woordenlijstPartOfSpeechCode) {
    switch (woordenlijstPartOfSpeechCode) {
      case "AA":
        return WordType.adjective;
      case "ADV":
        return WordType.adverb;
      case "ADP":
        return WordType.preposition;
      case "NOU-C":
      case "NOU-P":
        return WordType.noun;
      case "INT":
        return WordType.interjection;
      case "CONJ":
        return WordType.conjuction;
      case "COLL":
        return WordType.fixedConjuction;
      case "PD":
        return WordType.pronoun;
      case "NUM":
        return WordType.numeral;
      case "VRB":
        return WordType.verb;
      case "RES":
      default:
        return WordType.none;
    }
  }

  static String? toPartOfSpeechCode(WordType? wordType) {
    if (wordType == null) {
      return null;
    }

    switch (wordType) {
      case WordType.adjective:
        return "AA";
      case WordType.adverb:
        return "ADV";
      case WordType.preposition:
        return "ADP";
      case WordType.noun:
        return "NOU-C|NOU-P";
      case WordType.interjection:
        return "INT";
      case WordType.conjuction:
        return "CONJ";
      case WordType.fixedConjuction:
        return "COLL";
      case WordType.pronoun:
        return "PD";
      case WordType.numeral:
        return "NUM";
      case WordType.verb:
        return "VRB";
      case WordType.none:
      default:
        return null;
    }
  }
}