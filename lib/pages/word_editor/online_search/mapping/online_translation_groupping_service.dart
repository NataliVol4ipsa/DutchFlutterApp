import 'package:collection/collection.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/woordenlijst/models/get_words_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_group.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/word_forms.dart';

class OnlineTranslationGrouppingService {
  static List<OnlineTranslationGroup> group(
      String searchedWord,
      List<DutchToEnglishTranslation> translationOptions,
      GetWordsGrammarOnlineResponse? grammarOptions) {
    List<WordForms> wordForms =
        _generateWordForms(searchedWord, grammarOptions);

    List<bool> isGrouppedTranslationFlags =
        List.filled(translationOptions.length, false);

    final List<OnlineTranslationGroup> grouppedResult = [];
    for (int i = 0; i < translationOptions.length; i++) {
      if (isGrouppedTranslationFlags[i]) {
        continue;
      }
      List<DutchToEnglishTranslation> newGroup = [];
      newGroup.add(translationOptions[i]);
      isGrouppedTranslationFlags[i] = true;
      WordForms? matchingWordForm =
          _findMatchingWordForm(wordForms, translationOptions[i]);

      for (int j = i + 1; j < translationOptions.length; j++) {
        if (isGrouppedTranslationFlags[j] ||
            translationOptions[j].partOfSpeech !=
                translationOptions[i].partOfSpeech) {
          continue;
        }
        if ((matchingWordForm != null &&
                matchingWordForm.isFormOf(translationOptions[j])) ||
            (translationOptions[i]
                    .dutchWords
                    .any((w) => w.word == searchedWord) &&
                translationOptions[j].dutchWords.any(
                    (w) => w.word == searchedWord))) //todo compare article too.
        {
          isGrouppedTranslationFlags[j] = true;
          newGroup.add(translationOptions[j]);
        }
      }
      grouppedResult.add(OnlineTranslationGroup(
          newGroup, matchingWordForm, translationOptions[i].partOfSpeech));
    }
    return grouppedResult;
  }

  static WordForms? _findMatchingWordForm(
      List<WordForms> wordForms, DutchToEnglishTranslation translation) {
    return wordForms.firstWhereOrNull((form) =>
        form.partOfSpeech == translation.partOfSpeech &&
        form.isFormOf(translation));
  }

  static List<WordForms> _generateWordForms(
      String searchedWord, GetWordsGrammarOnlineResponse? grammarOptions) {
    return grammarOptions?.onlineWords
            .where((w) => w.partOfSpeech != null)
            .map((o) => WordForms(searchedWord: searchedWord, grammarOption: o))
            .toList() ??
        [];
  }
}
