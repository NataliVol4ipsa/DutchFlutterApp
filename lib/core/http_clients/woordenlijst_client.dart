import 'package:first_project/core/http_clients/get_word_online_response.dart';
import 'package:first_project/core/http_clients/get_words_online_response.dart';
import 'package:first_project/core/http_clients/xml_extensions.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class WoordenlijstClient {
  Future<GetWordsOnlineResponse> findAsync(String word,
      {WordType? wordType}) async {
    String? partOfSpeech = toPartOfSpeechCode(wordType);
    String partOfSpeechQueryParam =
        partOfSpeech == null ? "" : "&part_of_speech=$partOfSpeech";
    final uri =
        Uri.parse('https://woordenlijst.org/MolexServe/lexicon/find_wordform'
            '?database=gig_pro_wrdlst&wordform=$word$partOfSpeechQueryParam'
            '&onlyvalid=true&regex=false&diminutive=true&paradigm=true');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return parseResponse(word, response.body);
    } else {
      throw Exception("Something went wrong");
    }
  }

  GetWordsOnlineResponse parseResponse(String searchText, String xmlString) {
    var sections = identifyWordSection(searchText, xmlString);
    var response = GetWordsOnlineResponse();
    for (var section in sections) {
      GetWordOnlineResponse wordResponse = processSection(searchText, section);
      response.onlineWords.add(wordResponse);
    }
    return response;
  }

  GetWordOnlineResponse processSection(
      String searchText, xml.XmlElement section) {
    var result = GetWordOnlineResponse(searchText);
    result.diminutive = findDiminutive(section);
    result.pluralForm = findPluralForm(section);
    var additionalInfo = findAdditionalProperties(section);
    result.partOfSpeech = parseAdditionalInfoIntoSpeech(additionalInfo);
    result.gender = parseAdditionalInfoIntoGender(additionalInfo);
    return result;
  }

  List<xml.XmlElement> identifyWordSection(
      String searchText, String xmlString) {
    var document = xml.XmlDocument.parse(xmlString);

    return document.findAllWithChildText('found_lemmata', 'lemma', searchText);
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

  String? toPartOfSpeechCode(WordType? wordType) {
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
