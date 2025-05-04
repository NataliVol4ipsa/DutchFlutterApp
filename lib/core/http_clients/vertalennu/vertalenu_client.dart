import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/core/http_clients/vertalennu/parsing/get_dutch_to_english_html_response_parser.dart';
import 'package:dutch_app/core/http_clients/vertalennu/models/dutch_to_english_search_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VertalenNuClient {
  static String baseUrl = "https://www.vertalen.nu/";

  Future<DutchToEnglishSearchResponse?> findDutchToEnglishAsync(
      BuildContext context, String word) async {
    final uri = Uri.parse('$baseUrl/vertaal'
        '?van=nl'
        '&naar=en'
        '&vertaal=$word');
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return GetDutchToEnglishHtmlResponseParser()
            .parseResponse(response.body, word);
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
