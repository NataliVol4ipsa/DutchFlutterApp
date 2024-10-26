import 'package:first_project/core/http_clients/get_word_online_response.dart';
import 'package:first_project/core/http_clients/xml_extensions.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class WoordenlijstClient {
  Future<GetWordOnlineResponse?> findAsync(String word,
      {String? partOfSpeech}) async {
    if (partOfSpeech == null) throw Exception("not supported");

    final uri = Uri.parse(
        'https://woordenlijst.org/MolexServe/lexicon/find_wordform'
        '?database=gig_pro_wrdlst&wordform=$word&part_of_speech=$partOfSpeech'
        '&onlyvalid=true&regex=false&diminutive=true&paradigm=true');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return parseResponse(word, response.body);
    } else {
      throw Exception("Something went wrong");
    }
  }

  GetWordOnlineResponse? parseResponse(String searchText, String xmlString) {
    xml.XmlElement? section = identifyWordSection(searchText, xmlString);
    if (section == null) {
      return null;
    }

    var result = GetWordOnlineResponse(searchText);
    result.diminutive = findDiminutive(section);
    result.pluralForm = findPluralForm(section);
    var additionalInfo = findAdditionalProperties(section);
    result.partOfSpeech = parseAdditionalInfoIntoSpeech(additionalInfo);
    result.gender = parseAdditionalInfoIntoGender(additionalInfo);
    return result;
  }

  xml.XmlElement? identifyWordSection(String searchText, String xmlString) {
    var document = xml.XmlDocument.parse(xmlString);

    return document.findFirstWithChildText(
        'found_lemmata', 'lemma', searchText);
  }

  String? findDiminutive(xml.XmlElement section) {
    return section
        .findFirst('diminutives')
        .findFirst('diminutives')
        .findFirstText('lemma');
  }

  String? findPluralForm(xml.XmlElement section) {
    return section
        .findFirst('paradigm')
        .findFirstWithChildText('paradigm', 'label', 'meervoud')
        .findFirstText('wordform');
  }

  String? findAdditionalProperties(xml.XmlElement section) {
    return section.findFirstText('lemma_part_of_speech');
  }

  //todo move out
  WordType parseAdditionalInfoIntoSpeech(String? value) {
    if (value == null) {
      return WordType.none;
    }
    RegExp regExp = RegExp(r'^(\w+-\w+)');
    Match? match = regExp.firstMatch(value);

    if (match != null) {
      String speechPartCode = match.group(0)!;
      return toWordType(speechPartCode);
    } else {
      return WordType.none;
    }
  }

  WordType toWordType(String woordenlijstPartOfSpeechCode) {
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

  DeHetType parseAdditionalInfoIntoGender(String? value) {
    if (value == null) {
      return DeHetType.none;
    }

    var genderCode = parseAdditionalInfoIntoParamInBraces(value, 'gender');
    switch (genderCode) {
      case 'm':
        return DeHetType.de;
      case 'n':
        return DeHetType.het;
      default:
        return DeHetType.none;
    }
  }

  String? parseAdditionalInfoIntoParamInBraces(String value, String paramName) {
    RegExp regExp = RegExp('$paramName=([a-zA-Z]+)');
    Match? match = regExp.firstMatch(value);
    if (match != null) {
      return match.group(1)!;
    } else {
      return null;
    }
  }
}
