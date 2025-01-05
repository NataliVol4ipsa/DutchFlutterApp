import 'package:dutch_app/core/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/core/notifiers/session_completed_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<ChangeNotifierProvider> notifierProviders() {
  return [
    ChangeNotifierProvider<ExerciseAnsweredNotifier>(
      create: (context) {
        debugPrint('Initializing LearningTaskAnsweredNotifier');
        return ExerciseAnsweredNotifier();
      },
    ),
    ChangeNotifierProvider<SessionCompletedNotifier>(
      create: (context) {
        debugPrint('Initializing LearningTasksCompletedNotifier');
        return SessionCompletedNotifier();
      },
    ),
  ];
}
