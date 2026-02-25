import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/pages/learning_session/pre_session_word_list_page.dart';
import 'package:dutch_app/pages/learning_session/session_page.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:flutter/material.dart';

class QuickPracticeCoordinator extends ChangeNotifier {
  final QuickPracticeService _quickPracticeService;
  final WordProgressService _wordProgressService;
  final ExerciseAnsweredNotifier _exerciseAnsweredNotifier;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  QuickPracticeCoordinator({
    required QuickPracticeService quickPracticeService,
    required WordProgressService wordProgressService,
    required ExerciseAnsweredNotifier exerciseAnsweredNotifier,
  }) : _quickPracticeService = quickPracticeService,
       _wordProgressService = wordProgressService,
       _exerciseAnsweredNotifier = exerciseAnsweredNotifier;

  Future<void> startAsync(BuildContext context) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final session = await _quickPracticeService.buildSessionAsync(
        wordProgressService: _wordProgressService,
        notifier: _exerciseAnsweredNotifier,
      );

      if (!context.mounted) return;

      if (session.showPreSessionWordList) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PreSessionWordListPage(flowManager: session.flowManager),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LearningSessionPage(flowManager: session.flowManager),
          ),
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
