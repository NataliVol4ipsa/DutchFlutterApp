import 'package:dutch_app/http_clients/woordenlijst/get_word_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_words_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/gender_converter.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/word_type_converter.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/woordenlijst/xml_extensions.dart';
import 'package:xml/xml.dart' as xml;

class GetWordsOnlineXmlResponseParser {
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
    result.note = findNote(section);
    return result;
  }

  List<xml.XmlElement> identifyWordSectionFiltered(
      String searchText, String xmlString) {
    xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllWithChildText('found_lemmata', 'lemma', searchText);
  }

  List<xml.XmlElement> identifyWordSection(
      String searchText, String xmlString) {
    xml.XmlDocument document = xml.XmlDocument.parse(xmlString);

    return document.findAllElements('found_lemmata').toList();
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

  String? findNote(xml.XmlElement section) {
    return section.findFirstText('gloss');
  }

  String? findAdditionalProperties(xml.XmlElement section) {
    return section.findFirstText('lemma_part_of_speech');
  }

  WordType parseAdditionalInfoIntoSpeech(String? value) {
    if (value == null) {
      return WordType.unspecified;
    }
    String result = value.replaceAll(RegExp(r'\(.*$'), '');
    if (result.trim() == "") {
      return WordType.unspecified;
    }

    return WordTypeConverter.toWordType(result);
  }

  DeHetType parseAdditionalInfoIntoGender(String? value) {
    if (value == null) {
      return DeHetType.none;
    }

    String? genderCode = parseAdditionalInfoIntoParamInBraces(value, 'gender');
    return GenderConverter.convert(genderCode);
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
