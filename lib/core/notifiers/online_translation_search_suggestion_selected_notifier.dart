import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_grammar_online_response.dart';
import 'package:flutter/material.dart';

// v2. Should be kept
class OnlineTranslationSearchSuggestionSelectedNotifier extends ChangeNotifier {
  DutchToEnglishTranslation? translation;
  List<GetWordGrammarOnlineResponse>? grammarOptions;

  void notify(DutchToEnglishTranslation translation) {
    this.translation = translation;
    notifyListeners();
  }

  void setGrammarOptions(List<GetWordGrammarOnlineResponse>? grammarOptions) {
    this.grammarOptions = grammarOptions;
  }

  void reset() {
    translation = null;
    grammarOptions = null;
  }
}
