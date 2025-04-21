import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_words_grammar_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/get_words_online_xml_response_parser.dart';
import 'package:dutch_app/http_clients/woordenlijst/mapping/word_type_converter.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WoordenlijstClient {
  static String baseUrl = "https://woordenlijst.org";

  Future<GetWordsGrammarOnlineResponse?> findAsync(
      BuildContext context, String word,
      {WordType? wordType}) async {
    String? partOfSpeech = WordTypeConverter.toPartOfSpeechCode(wordType);
    String partOfSpeechQueryParam =
        partOfSpeech == null ? "" : "&part_of_speech=$partOfSpeech";
    final uri = Uri.parse('$baseUrl/MolexServe/lexicon/find_wordform'
        '?database=gig_pro_wrdlst'
        '&wordform=$word'
        '$partOfSpeechQueryParam'
        '&onlyvalid=true'
        '&regex=false'
        '&diminutive=true'
        '&paradigm=true');
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return GetWordsOnlineXmlResponseParser()
            .parseResponse(word, response.body);
      } else {
        notifyOnlineWordSearchErrorOccurred(context,
            errorStatusCode: response.statusCode,
            errorMesssage: response.reasonPhrase);
        return null;
      }
    } catch (ex) {
      notifyOnlineWordSearchErrorOccurred(context, errorMesssage: "$ex");
      return null;
    }
  }
}
