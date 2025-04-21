import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:flutter/material.dart';

// v2. Should be kept
class OnlineTranslationSearchSuggestionSelectedNotifier extends ChangeNotifier {
  DutchToEnglishTranslation? translation;

  void notify(DutchToEnglishTranslation translation) {
    this.translation = translation;
    notifyListeners();
  }

  void reset() {
    translation = null;
  }
}
