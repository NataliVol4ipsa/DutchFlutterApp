import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/practice_session_stateful_service.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/pages/learning_session/pre_session_word_list_page.dart';
import 'package:dutch_app/pages/learning_session/session_page.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:dutch_app/pages/quick_practice/extra_practice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> startQuickPracticeAsync(BuildContext context) async {
    await _startAsync(context, words: null);
  }

  Future<void> startQuickPracticeFromWordsAsync(
    BuildContext context,
    List<Word> words,
  ) async {
    await _startAsync(context, words: words);
  }

  Future<void> _startAsync(
    BuildContext context, {
    required List<Word>? words,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final practiceService = context.read<PracticeSessionStatefulService>();
    final settingsService = context.read<SettingsService>();

    try {
      final alreadyPracticedToday = await _wordProgressService
          .practicedTodayAsync();

      if (!context.mounted) return;

      if (alreadyPracticedToday) {
        // ── User already practiced today → offer extra practice ────────────
        // This gate applies to both the global and word-collection modes so
        // that completing one counts as "practiced" for the other.
        _isLoading = false;
        notifyListeners();

        final chosenSettings = await showExtraPracticeDialog(context);

        if (!context.mounted) return;
        if (chosenSettings == null) {
          // User pressed "No" – do nothing.
          return;
        }

        // Persist the bucket choices for next time.
        final currentSettings = await settingsService.getSettingsAsync();
        await settingsService.updateSettingsAsync(
          Settings(
            theme: currentSettings.theme,
            session: currentSettings.session,
            extraPractice: chosenSettings,
          ),
        );

        if (!context.mounted) return;
        _isLoading = true;
        notifyListeners();

        await _runExtraPracticeSession(
          context,
          practiceService,
          chosenSettings,
          words: words,
        );
      } else {
        // ── Normal scheduled session ───────────────────────────────────────
        if (words != null) {
          await _runSessionFromWords(context, practiceService, words);
        } else {
          await _runRegularSession(context, practiceService);
        }
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      practiceService.cleanup();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _runRegularSession(
    BuildContext context,
    PracticeSessionStatefulService practiceService,
  ) async {
    final session = await _quickPracticeService.buildSessionAsync(
      wordProgressService: _wordProgressService,
      notifier: _exerciseAnsweredNotifier,
    );

    if (!context.mounted) return;

    practiceService.initializeWords(session.flowManager.words);
    await _navigateToSession(context, session);
  }

  Future<void> _runSessionFromWords(
    BuildContext context,
    PracticeSessionStatefulService practiceService,
    List<Word> words,
  ) async {
    final session = await _quickPracticeService.buildSessionFromWordsAsync(
      words: words,
      wordProgressService: _wordProgressService,
      notifier: _exerciseAnsweredNotifier,
    );

    if (!context.mounted) return;

    practiceService.initializeWords(session.flowManager.words);
    await _navigateToSession(context, session);
  }

  Future<void> _runExtraPracticeSession(
    BuildContext context,
    PracticeSessionStatefulService practiceService,
    ExtraPracticeSettings settings, {
    List<Word>? words,
  }) async {
    final session = await _quickPracticeService.buildExtraPracticeSessionAsync(
      extraPracticeSettings: settings,
      wordProgressService: _wordProgressService,
      notifier: _exerciseAnsweredNotifier,
      allowedWordIds: words?.map((w) => w.id).toSet(),
    );

    if (!context.mounted) return;

    practiceService.initializeWords(session.flowManager.words);
    await _navigateToSession(context, session);
  }

  Future<void> _navigateToSession(
    BuildContext context,
    QuickPracticeSession session,
  ) async {
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
          builder: (_) => LearningSessionPage(flowManager: session.flowManager),
        ),
      );
    }
  }
}
