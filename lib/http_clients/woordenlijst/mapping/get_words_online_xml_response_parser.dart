import 'package:collection/collection.dart';
import 'package:dutch_app/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/models/get_words_grammar_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/gender_converter.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/word_type_converter.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/woordenlijst/xml_extensions.dart';
import 'package:xml/xml.dart' as xml;

class GetWordsOnlineXmlResponseParser {
  GetWordsGrammarOnlineResponse parseResponse(
      String searchText, String xmlString) {
    var sections = identifyWordSection(searchText, xmlString);
    var response = GetWordsGrammarOnlineResponse();
    for (var section in sections) {
      GetWordGrammarOnlineResponse wordResponse =
          processSection(searchText, section);
      response.onlineWords.add(wordResponse);
    }
    return response;
  }

  GetWordGrammarOnlineResponse processSection(
      String searchText, xml.XmlElement section) {
    var result = GetWordGrammarOnlineResponse(searchText);
    result.diminutive = findDiminutive(section);
    result.pluralForm = findPluralForm(section);
    var additionalInfo = findAdditionalProperties(section);
    result.partOfSpeech = parseAdditionalInfoIntoSpeech(additionalInfo);
    result.gender = parseAdditionalInfoIntoGender(additionalInfo);
    result.note = findNote(section);
    result.verbDetails.infinitive =
        _findWordFormByGroupLabel(section, 'infinitief');
    result.verbDetails.completedParticiple =
        _findWordFormByGroupLabel(section, 'aanvoegende wijs');
    result.verbDetails.auxiliaryVerb =
        _findWordFormByGroupLabel(section, 'voltooid deelwoord');
    addPresentTense(result, section);
    addPastTense(result, section);
    addImperative(result, section);
    addPresentParticiple(result, section);

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

  String? _findWordFormByGroupLabel(xml.XmlElement section, String groupLabel) {
    return section
        .findFirst('paradigm')
        .findFirstWithChildText('paradigm', 'group_label', groupLabel)
        .findFirstText('wordform');
  }

  String? _findWordFormByGroupAndLabel(
    xml.XmlElement section,
    String groupLabel,
    String label,
  ) {
    return section.findFirst('paradigm')?.findFirstWhereChildTextEquals(
      sectionName: 'paradigm',
      conditions: {
        'group_label': groupLabel,
        'label': label,
      },
    )?.findFirstText('wordform');
  }

  String? _findWordFormByGroupLabelLabelAndPartOfSpeechContains(
    xml.XmlElement section,
    String groupLabel,
    String label,
    String partOfSpeechContains,
  ) {
    return section
        .findFirst('paradigm')
        ?.findAllElements('paradigm')
        .firstWhereOrNull((e) =>
            e.findFirstText('group_label') == groupLabel &&
            e.findFirstText('label') == label &&
            (e
                    .findFirstText('part_of_speech')
                    ?.contains(partOfSpeechContains) ??
                false))
        ?.findFirstText('wordform');
  }

  // Needs further unit testing
  void addImperative(
      GetWordGrammarOnlineResponse result, xml.XmlElement section) {
    var groupLabel = "gebiedende wijs";
    result.verbDetails.imperative.informal =
        _findWordFormByGroupAndLabel(section, groupLabel, "");
    result.verbDetails.imperative.formal =
        _findWordFormByGroupAndLabel(section, groupLabel, "u");
  }

  void addPresentParticiple(
      GetWordGrammarOnlineResponse result, xml.XmlElement section) {
    var groupLabel = "tegenwoordig deelwoord";
    result.verbDetails.presentParticiple.uninflected =
        _findWordFormByGroupLabel(section, groupLabel);
    result.verbDetails.presentParticiple.inflected =
        _findWordFormByGroupLabelLabelAndPartOfSpeechContains(
            section, groupLabel, "", "infl=e");
  }

  void addPresentTense(
      GetWordGrammarOnlineResponse result, xml.XmlElement section) {
    var groupLabel = "tegenwoordige tijd";
    result.verbDetails.presentTense.ik =
        _findWordFormByGroupAndLabel(section, groupLabel, "ik");
    result.verbDetails.presentTense.jijVraag =
        _findWordFormByGroupLabelLabelAndPartOfSpeechContains(
            section, groupLabel, "jij", "position=bs");
    result.verbDetails.presentTense.jij =
        _findWordFormByGroupLabelLabelAndPartOfSpeechContains(
            section, groupLabel, "jij", "position=bs");
    result.verbDetails.presentTense.u =
        _findWordFormByGroupAndLabel(section, groupLabel, "u");
    result.verbDetails.presentTense.hijZijHet =
        _findWordFormByGroupAndLabel(section, groupLabel, "hij/zij/het");
    result.verbDetails.presentTense.wij =
        _findWordFormByGroupAndLabel(section, groupLabel, "wij");
    result.verbDetails.presentTense.jullie =
        _findWordFormByGroupAndLabel(section, groupLabel, "jullie");
    result.verbDetails.presentTense.zij =
        _findWordFormByGroupAndLabel(section, groupLabel, "zij");
  }

  void addPastTense(
      GetWordGrammarOnlineResponse result, xml.XmlElement section) {
    var groupLabel = "verleden tijd";
    result.verbDetails.pastTense.ik =
        _findWordFormByGroupAndLabel(section, groupLabel, "ik");
    result.verbDetails.pastTense.jij =
        _findWordFormByGroupAndLabel(section, groupLabel, "jij");
    result.verbDetails.pastTense.hijZijHet =
        _findWordFormByGroupAndLabel(section, groupLabel, "hij/zij/het");
    result.verbDetails.pastTense.wij =
        _findWordFormByGroupAndLabel(section, groupLabel, "wij");
    result.verbDetails.pastTense.jullie =
        _findWordFormByGroupAndLabel(section, groupLabel, "jullie");
    result.verbDetails.pastTense.zij =
        _findWordFormByGroupAndLabel(section, groupLabel, "zij");
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
