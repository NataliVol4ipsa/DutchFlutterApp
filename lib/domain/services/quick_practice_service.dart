import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/exercise_mode_quota.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';

class QuickPracticeSession {
  final LearningSessionManager flowManager;
  final bool showPreSessionWordList;

  const QuickPracticeSession({
    required this.flowManager,
    required this.showPreSessionWordList,
  });
}

class QuickPracticeService {
  final WordsRepository wordsRepository;
  final WordProgressBatchRepository wordProgressRepository;
  final SettingsService settingsService;
  final ExerciseModeQuota quota;

  QuickPracticeService({
    required this.wordsRepository,
    required this.wordProgressRepository,
    required this.settingsService,
    ExerciseModeQuota? quota,
  }) : quota = quota ?? ExerciseModeQuota.flipCardOnly;

  Future<QuickPracticeSession> buildSessionAsync({
    required WordProgressService wordProgressService,
    required ExerciseAnsweredNotifier notifier,
  }) async {
    final settings = await settingsService.getSettingsAsync();
    final sessionSettings = settings.session;
    final activeTypes = quota.activeTypes;

    final reviewWords = await _fetchReviewWordsAsync(
      activeTypes,
      sessionSettings.repetitionsPerSession,
    );
    final reviewWordIds = reviewWords.map((w) => w.id).toSet();

    final newWords = await _fetchNewWordsAsync(
      activeTypes,
      sessionSettings.newWordsPerSession,
      excludeIds: reviewWordIds,
    );

    final practiceableWords = [...newWords, ...reviewWords];
    if (practiceableWords.isEmpty) {
      throw Exception(
        'No eligible words for practice right now.\n'
        'All due words may have been studied recently, or there are no new words to learn.',
      );
    }

    final flowManager = LearningSessionManager(
      activeTypes,
      practiceableWords,
      wordProgressService,
      notifier,
      useAnkiMode: sessionSettings.useAnkiMode,
    );

    return QuickPracticeSession(
      flowManager: flowManager,
      showPreSessionWordList: sessionSettings.showPreSessionWordList,
    );
  }

  Future<List<Word>> _fetchReviewWordsAsync(
    List<ExerciseType> activeTypes,
    int limit,
  ) async {
    final detailedTypes = activeTypes
        .expand((t) => t.detailedTypes)
        .toSet()
        .toList();

    final allDueProgress = <DbWordProgress>[];
    for (final type in detailedTypes) {
      allDueProgress.addAll(
        await wordProgressRepository.getDueProgressAsync(type, limit),
      );
    }
    if (detailedTypes.length > 1) {
      allDueProgress.sort(
        (a, b) => a.nextReviewDate.compareTo(b.nextReviewDate),
      );
    }

    final words = <Word>[];
    final seenIds = <int>{};
    for (final progress in allDueProgress.take(limit)) {
      final wordId = progress.word.value?.id;
      if (wordId == null || seenIds.contains(wordId)) continue;
      final word = await wordsRepository.getWordAsync(wordId);
      if (word != null && _isSupportedByAnyType(activeTypes, word)) {
        words.add(word);
        seenIds.add(wordId);
        if (words.length >= limit) break;
      }
    }
    return words;
  }

  Future<List<Word>> _fetchNewWordsAsync(
    List<ExerciseType> activeTypes,
    int limit, {
    required Set<int> excludeIds,
  }) async {
    final candidates = await wordsRepository.getNewWordsAsync(limit * 3);
    final words = <Word>[];
    for (final word in candidates) {
      if (excludeIds.contains(word.id)) continue;
      if (_isSupportedByAnyType(activeTypes, word)) {
        words.add(word);
        if (words.length >= limit) break;
      }
    }
    return words;
  }

  bool _isSupportedByAnyType(List<ExerciseType> types, Word word) {
    return types.any((type) => _isSupportedByType(type, word));
  }

  bool _isSupportedByType(ExerciseType type, Word word) {
    switch (type) {
      case ExerciseType.flipCard:
        return FlipCardExercise.isSupportedWord(word);
      case ExerciseType.deHetPick:
        return DeHetPickExercise.isSupportedWord(word);
      case ExerciseType.manyToMany:
        return ManyToManyExercise.isSupportedWord(word);
      case ExerciseType.basicWrite:
        return WriteExercise.isSupportedWord(word);
      case ExerciseType.pluralFormPick:
      case ExerciseType.pluralFormWrite:
      case ExerciseType.basicOnePick:
        return false;
    }
  }

  Future<QuickPracticeSession> buildSessionFromWordsAsync({
    required List<Word> words,
    required WordProgressService wordProgressService,
    required ExerciseAnsweredNotifier notifier,
  }) async {
    final settings = await settingsService.getSettingsAsync();
    final sessionSettings = settings.session;
    final activeTypes = quota.activeTypes;

    final supportedWords = words
        .where((w) => _isSupportedByAnyType(activeTypes, w))
        .toList();

    final wordIds = supportedWords.map((w) => w.id).toList();
    final practicedIds = await wordProgressService.getPracticedWordIdsAsync(
      wordIds,
    );

    final newWords = supportedWords
        .where((w) => !practicedIds.contains(w.id))
        .take(sessionSettings.newWordsPerSession)
        .toList();

    final reviewWords = supportedWords
        .where((w) => practicedIds.contains(w.id))
        .take(sessionSettings.repetitionsPerSession)
        .toList();

    final practiceableWords = [...newWords, ...reviewWords];

    if (practiceableWords.isEmpty) {
      throw Exception(
        'None of the selected words can be used for practice with the current exercise settings.',
      );
    }

    final flowManager = LearningSessionManager(
      activeTypes,
      practiceableWords,
      wordProgressService,
      notifier,
      useAnkiMode: sessionSettings.useAnkiMode,
    );

    return QuickPracticeSession(
      flowManager: flowManager,
      showPreSessionWordList: sessionSettings.showPreSessionWordList,
    );
  }
}
