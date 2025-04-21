import 'package:dutch_app/core/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/core/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/notifiers/online_word_search_error_notifier.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/notifiers/session_completed_notifier.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:provider/provider.dart';

List<ChangeNotifierProvider> notifierProviders() {
  return [
    ChangeNotifierProvider<ExerciseAnsweredNotifier>(
      create: (context) {
        return ExerciseAnsweredNotifier();
      },
    ),
    ChangeNotifierProvider<SessionCompletedNotifier>(
      create: (context) {
        return SessionCompletedNotifier();
      },
    ),
    ChangeNotifierProvider<OnlineWordSearchErrorNotifier>(
      create: (context) {
        return OnlineWordSearchErrorNotifier();
      },
    ),
    ChangeNotifierProvider<OnlineWordSearchSuggestionSelectedNotifier>(
      create: (context) {
        return OnlineWordSearchSuggestionSelectedNotifier();
      },
    ),
    ChangeNotifierProvider<OnlineTranslationSearchSuggestionSelectedNotifier>(
      create: (context) {
        return OnlineTranslationSearchSuggestionSelectedNotifier();
      },
    ),
    ChangeNotifierProvider<WordCreatedNotifier>(
      create: (context) {
        return WordCreatedNotifier();
      },
    ),
  ];
}
