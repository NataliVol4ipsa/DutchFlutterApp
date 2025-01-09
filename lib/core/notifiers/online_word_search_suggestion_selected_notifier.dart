import 'package:dutch_app/http_clients/get_word_online_response.dart';
import 'package:flutter/material.dart';

class OnlineWordSearchSuggestionSelectedNotifier extends ChangeNotifier {
  GetWordOnlineResponse? wordOption;

  void notify(GetWordOnlineResponse wordOption) {
    this.wordOption = wordOption;
    notifyListeners();
  }

  void reset() {
    wordOption = null;
  }
}
