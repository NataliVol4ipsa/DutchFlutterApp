import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_grammar_online_response.dart';

class OnlineTranslationPostProcessingService {
  static String? findNounPluralForm(WordType translationWordType,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    if (translationWordType != WordType.noun || grammarOptions == null) {
      return null;
    }

    for (var option in grammarOptions) {
      if (option.partOfSpeech == WordType.noun &&
          option.pluralForm != null &&
          option.pluralForm!.trim().isNotEmpty) {
        return option.pluralForm;
      }
    }

    return null;
  }
}
