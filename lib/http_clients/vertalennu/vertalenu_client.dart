import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/http_clients/vertalennu/mapping/get_dutch_to_english_html_response_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VertalenNuClient {
  static String baseUrl = "https://www.vertalen.nu/";

  Future<void> findDutchToEnglishAsync(
      BuildContext context, String word) async {
    final uri = Uri.parse('$baseUrl/vertaal'
        '?van=nl'
        '&naar=en'
        '&vertaal=$word');
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        GetDutchToEnglishHtmlResponseParser().parseResponse(response.body);
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
