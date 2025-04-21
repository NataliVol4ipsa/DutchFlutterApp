import 'package:dutch_app/core/types/word_type.dart';

class OnlineTranslationPostProcessingService {
  static String? findNounPluralForm(WordType translationWordType) {
    if (translationWordType != WordType.noun) return null;

    return "";
  }
}
