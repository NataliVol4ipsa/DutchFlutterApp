import 'package:dutch_app/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:flutter/material.dart';

// v2. Should be kept
class OnlineTranslationSearchSuggestionSelectedNotifier extends ChangeNotifier {
  TranslationSearchResult? translation;
  List<GetWordGrammarOnlineResponse>? grammarOptions;

  void notify(TranslationSearchResult translation) {
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
