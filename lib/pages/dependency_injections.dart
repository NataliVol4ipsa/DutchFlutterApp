import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/domain/notifiers/online_word_search_error_notifier.dart';
import 'package:dutch_app/domain/notifiers/session_completed_notifier.dart';
import 'package:dutch_app/domain/notifiers/word_created_notifier.dart';
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
