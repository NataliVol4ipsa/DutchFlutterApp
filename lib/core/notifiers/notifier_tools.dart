import 'package:dutch_app/core/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/core/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/core/notifiers/online_word_search_error_notifier.dart';
import 'package:dutch_app/core/notifiers/session_completed_notifier.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void notifyAnsweredExercise(BuildContext context, bool isAnswered) {
  Provider.of<ExerciseAnsweredNotifier>(context, listen: false)
      .notifyAnswerUpdated(isAnswered);
}

void notifyCompletedTasks(BuildContext context) {
  Provider.of<SessionCompletedNotifier>(context, listen: false)
      .notifyCompleted();
}

void notifyDarkThemeToggled(BuildContext context, bool useDarkMode) {
  Provider.of<DarkThemeToggledNotifier>(context, listen: false)
      .setDarkTheme(useDarkMode);
}

void notifyOnlineWordSearchErrorOccurred(BuildContext context,
    {int? errorStatusCode, String? errorMesssage}) {
  Provider.of<OnlineWordSearchErrorNotifier>(context, listen: false)
      .notifyOccurred(
          errorStatusCode: errorStatusCode, errorMesssage: errorMesssage);
}

void notifyWordCreated(BuildContext context) {
  Provider.of<WordCreatedNotifier>(context, listen: false).notify();
}
