import 'package:first_project/pages/learning_session/notifiers/exercise_answered_notifier.dart';
import 'package:first_project/pages/learning_session/notifiers/session_completed_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void notifyAnsweredTask(BuildContext context, bool isAnswered) {
  Provider.of<ExerciseAnsweredNotifier>(context, listen: false)
      .notifyAnswerUpdated(isAnswered);
}

void notifyCompletedTasks(BuildContext context) {
  Provider.of<SessionCompletedNotifier>(context, listen: false)
      .notifyCompleted();
}
