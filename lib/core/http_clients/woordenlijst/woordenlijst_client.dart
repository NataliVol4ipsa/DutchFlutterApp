import 'dart:convert';

import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_words_grammar_online_response.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/mapping/get_words_online_xml_response_parser.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/mapping/word_type_converter.dart';
import 'package:dutch_app/domain/types/word_type.dart';
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
        final decodedBody = utf8.decode(response.bodyBytes);
        return GetWordsOnlineXmlResponseParser()
            .parseResponse(word, decodedBody);
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
