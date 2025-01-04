import 'package:dutch_app/http_clients/get_words_online_response.dart';
import 'package:dutch_app/http_clients/mapping/get_words_online_xml_response_parser.dart';
import 'package:dutch_app/http_clients/mapping/word_type_converter.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:http/http.dart' as http;

class WoordenlijstClient {
  static String baseUrl = "https://woordenlijst.org";

  Future<GetWordsOnlineResponse> findAsync(String word,
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

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return GetWordsOnlineXmlResponseParser()
          .parseResponse(word, response.body);
    } else {
      throw Exception("Something went wrong");
    }
  }
}
