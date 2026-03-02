import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/exercise_mode_quota.dart';
import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_english_dutch_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:flutter/foundation.dart';

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
    final sessionSettings = await _fetchSessionSettingsAsync();
    final activeTypes = quota.activeTypes;

    final reviewWords = await _fetchReviewWordsAsync(
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

    final allIds = practiceableWords.map((w) => w.id).toList();
    final progressByWordId = await wordProgressRepository
        .getProgressByWordIdAsync(allIds);
    final unlockedTypesById = computeUnlockedTypesPerWord(
      allIds,
      progressByWordId,
    );

    return _createSession(
      words: practiceableWords,
      activeTypes: activeTypes,
      sessionSettings: sessionSettings,
      wordProgressService: wordProgressService,
      notifier: notifier,
      unlockedTypesById: unlockedTypesById,
    );
  }

  /// Fetches review words using per-type proportional quotas from [quota].
  /// Delegates to [selectReviewWordsForQuickSession] so the logic is fully
  /// testable without a database.
  Future<List<Word>> _fetchReviewWordsAsync(int limit) async {
    return selectReviewWordsForQuickSession(
      quotaByType: quota.quotaByType,
      totalWords: limit,
      fetchDueProgress: _fetchDueProgressForTypeAsync,
      fetchWord: wordsRepository.getWordAsync,
      isWordSupportedForType: _isSupportedByType,
    );
  }

  /// Fetches due progress records for a single [ExerciseType], aggregating
  /// across all its [ExerciseTypeDetailed] variants and deduplicating by
  /// word id.
  Future<List<DbWordProgress>> _fetchDueProgressForTypeAsync(
    ExerciseType type,
    int limit,
  ) async {
    final result = <DbWordProgress>[];
    final seenWordIds = <int>{};
    for (final dt in type.detailedTypes) {
      if (result.length >= limit) break;
      final records = await wordProgressRepository.getDueProgressAsync(
        dt,
        limit,
      );
      for (final r in records) {
        if (result.length >= limit) break;
        final wId = r.word.value?.id;
        if (wId != null && seenWordIds.add(wId)) {
          result.add(r);
        }
      }
    }
    return result;
  }

  /// Selects review words for a quick-practice session.
  ///
  /// Each exercise type in [quotaByType] gets a proportional share of
  /// [totalWords] (normalised from the raw quota values). Words that appear
  /// in multiple types are deduplicated so the total never exceeds
  /// [totalWords]. A backfill pass fills any gap caused by cross-type
  /// duplicates.
  ///
  /// The method is `@visibleForTesting` so unit tests can drive it directly
  /// with in-memory callbacks, with zero DB involvement.
  @visibleForTesting
  static Future<List<Word>> selectReviewWordsForQuickSession({
    required Map<ExerciseType, double> quotaByType,
    required int totalWords,
    required Future<List<DbWordProgress>> Function(ExerciseType, int)
    fetchDueProgress,
    required Future<Word?> Function(int wordId) fetchWord,
    required bool Function(ExerciseType, Word) isWordSupportedForType,
  }) async {
    final activeEntries = quotaByType.entries
        .where((e) => e.value > 0)
        .toList();
    if (activeEntries.isEmpty || totalWords <= 0) return [];

    final totalWeight = activeEntries.fold(0.0, (s, e) => s + e.value);
    final normalizedWeights = <ExerciseType, double>{
      for (final e in activeEntries) e.key: e.value / totalWeight,
    };

    final seenIds = <int>{};
    final result = <Word>[];

    // ── First pass: proportional per-type quotas ──────────────────────────
    for (final entry in normalizedWeights.entries) {
      final type = entry.key;
      final targetCount = (totalWords * entry.value).round().clamp(
        1,
        totalWords,
      );

      final progressRecords = await fetchDueProgress(type, targetCount * 2);

      int added = 0;
      for (final progress in progressRecords) {
        if (added >= targetCount) break;
        final wordId = progress.word.value?.id;
        if (wordId == null || seenIds.contains(wordId)) continue;
        final word = await fetchWord(wordId);
        if (word != null && isWordSupportedForType(type, word)) {
          result.add(word);
          seenIds.add(wordId);
          added++;
        }
      }
    }

    // ── Backfill pass: fill gaps from cross-type duplicates ───────────────
    if (result.length < totalWords) {
      for (final type in normalizedWeights.keys) {
        if (result.length >= totalWords) break;
        final needed = totalWords - result.length;
        final fetchLimit = seenIds.length + needed * 2;

        final progressRecords = await fetchDueProgress(type, fetchLimit);

        for (final progress in progressRecords) {
          if (result.length >= totalWords) break;
          final wordId = progress.word.value?.id;
          if (wordId == null || seenIds.contains(wordId)) continue;
          final word = await fetchWord(wordId);
          if (word != null && isWordSupportedForType(type, word)) {
            result.add(word);
            seenIds.add(wordId);
          }
        }
      }
    }

    return result;
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
      case ExerciseType.flipCardReverse:
        return FlipCardEnglishDutchExercise.isSupportedWord(word);
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
    final sessionSettings = await _fetchSessionSettingsAsync();
    final activeTypes = quota.activeTypes;

    final supportedWords = words
        .where((w) => _isSupportedByAnyType(activeTypes, w))
        .toList();

    // Compute remaining daily new-word quota to share with the auto session.
    final alreadyNewToday = await wordProgressRepository
        .countNewWordsIntroducedTodayAsync();
    final remainingNewQuota =
        (sessionSettings.newWordsPerSession - alreadyNewToday).clamp(
          0,
          sessionSettings.newWordsPerSession,
        );

    final wordIds = supportedWords.map((w) => w.id).toList();
    final practicedIds = await wordProgressService.getPracticedWordIdsAsync(
      wordIds,
    );

    final newWords = supportedWords
        .where((w) => !practicedIds.contains(w.id))
        .take(remainingNewQuota)
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

    final allIds = practiceableWords.map((w) => w.id).toList();
    final progressByWordId = await wordProgressRepository
        .getProgressByWordIdAsync(allIds);
    final unlockedTypesById = computeUnlockedTypesPerWord(
      allIds,
      progressByWordId,
    );

    return _createSession(
      words: practiceableWords,
      activeTypes: activeTypes,
      sessionSettings: sessionSettings,
      wordProgressService: wordProgressService,
      notifier: notifier,
      unlockedTypesById: unlockedTypesById,
    );
  }

  Future<SessionSettings> _fetchSessionSettingsAsync() async {
    final settings = await settingsService.getSettingsAsync();
    return settings.session;
  }

  /// Builds a session for an optional extra-practice run (user already practiced
  /// today). Words are drawn from the buckets enabled in [extraPracticeSettings]
  /// with normalized weights. The session size equals [repetitionsPerSession].
  Future<QuickPracticeSession> buildExtraPracticeSessionAsync({
    required ExtraPracticeSettings extraPracticeSettings,
    required WordProgressService wordProgressService,
    required ExerciseAnsweredNotifier notifier,
  }) async {
    final sessionSettings = await _fetchSessionSettingsAsync();
    final activeTypes = quota.activeTypes;
    final detailedTypes = activeTypes
        .expand((t) => t.detailedTypes)
        .toSet()
        .toList();

    final allBucketWords = await selectWordsForExtraPractice(
      settings: extraPracticeSettings,
      totalWords: sessionSettings.repetitionsPerSession,
      fetchProgress: (bucket, limit) =>
          _fetchAcrossDetailedTypesAsync(bucket, detailedTypes, limit),
      fetchWord: wordsRepository.getWordAsync,
      isWordSupported: (w) => _isSupportedByAnyType(activeTypes, w),
    );

    if (allBucketWords.isEmpty) {
      throw Exception(
        'No words found for the selected extra-practice options.\n'
        'Try enabling more buckets or practice more words first.',
      );
    }

    return _createSession(
      words: allBucketWords,
      activeTypes: activeTypes,
      sessionSettings: sessionSettings,
      wordProgressService: wordProgressService,
      notifier: notifier,
    );
  }

  /// Selects words for an extra-practice session from multiple buckets.
  ///
  /// The algorithm:
  /// 1. **First pass** — each bucket gets proportional quota
  ///    (`round(totalWords × weight)`).  We ask the fetcher for `quota × 2`
  ///    records up-front so cross-bucket overlaps are less likely to starve a
  ///    bucket immediately.  Duplicates are dropped via [seenIds].
  /// 2. **Backfill pass** — if the first pass produced fewer than [totalWords]
  ///    words (because of overlap), we iterate buckets again (highest weight
  ///    first) and fill the remaining capacity.
  ///
  /// The method is `@visibleForTesting` so that unit tests can drive it
  /// directly with in-memory callbacks, with zero DB involvement.
  @visibleForTesting
  static Future<List<Word>> selectWordsForExtraPractice({
    required ExtraPracticeSettings settings,
    required int totalWords,
    required Future<List<DbWordProgress>> Function(
      ExtraPracticeBucket bucket,
      int limit,
    )
    fetchProgress,
    required Future<Word?> Function(int wordId) fetchWord,
    required bool Function(Word) isWordSupported,
  }) async {
    final weights = settings.normalizedWeights;
    if (weights.isEmpty) {
      throw Exception(
        'No extra-practice buckets selected. Please choose at least one option.',
      );
    }
    if (totalWords <= 0) return [];

    final seenIds = <int>{};
    final result = <Word>[];

    // ── First pass: proportional per-bucket quotas ─────────────────────────
    for (final entry in weights.entries) {
      final bucket = entry.key;
      final targetCount = (totalWords * entry.value).round().clamp(
        1,
        totalWords,
      );

      // Fetch 2× the target to absorb cross-bucket overlaps in one trip.
      final progressRecords = await fetchProgress(bucket, targetCount * 2);

      int added = 0;
      for (final progress in progressRecords) {
        if (added >= targetCount) break;
        final wordId = progress.word.value?.id;
        if (wordId == null || seenIds.contains(wordId)) continue;
        final word = await fetchWord(wordId);
        if (word != null && isWordSupported(word)) {
          result.add(word);
          seenIds.add(wordId);
          added++;
        }
      }
    }

    // ── Backfill pass: fill gaps caused by cross-bucket overlap ────────────
    if (result.length < totalWords) {
      for (final bucket in weights.keys) {
        if (result.length >= totalWords) break;
        final needed = totalWords - result.length;
        // Ask for enough records to skip every already-seen word AND still
        // find `needed` fresh ones: worst case all seen words appear first.
        final fetchLimit = seenIds.length + needed * 2;

        final progressRecords = await fetchProgress(bucket, fetchLimit);

        for (final progress in progressRecords) {
          if (result.length >= totalWords) break;
          final wordId = progress.word.value?.id;
          if (wordId == null || seenIds.contains(wordId)) continue;
          final word = await fetchWord(wordId);
          if (word != null && isWordSupported(word)) {
            result.add(word);
            seenIds.add(wordId);
          }
        }
      }
    }

    return result;
  }

  /// Fetches progress for [bucket] across all [detailedTypes], dedupes by id,
  /// and returns up to [limit] records.
  Future<List<DbWordProgress>> _fetchAcrossDetailedTypesAsync(
    ExtraPracticeBucket bucket,
    List<ExerciseTypeDetailed> detailedTypes,
    int limit,
  ) async {
    return fetchAcrossDetailedTypes(
      detailedTypes: detailedTypes,
      limit: limit,
      fetchByType: (dt, lim) => _fetchBucketProgressAsync(bucket, dt, lim),
    );
  }

  @visibleForTesting
  static Future<List<DbWordProgress>> fetchAcrossDetailedTypes({
    required List<ExerciseTypeDetailed> detailedTypes,
    required int limit,
    required Future<List<DbWordProgress>> Function(
      ExerciseTypeDetailed type,
      int limit,
    )
    fetchByType,
  }) async {
    final progressRecords = <DbWordProgress>[];
    final seenWordIds = <int>{};
    for (final detailedType in detailedTypes) {
      if (progressRecords.length >= limit) break;
      final records = await fetchByType(detailedType, limit);
      for (final r in records) {
        if (progressRecords.length >= limit) break;
        final wordId = r.word.value?.id;
        if (wordId != null && seenWordIds.add(wordId)) {
          progressRecords.add(r);
        }
      }
    }
    return progressRecords;
  }

  Future<List<DbWordProgress>> _fetchBucketProgressAsync(
    ExtraPracticeBucket bucket,
    ExerciseTypeDetailed detailedType,
    int limit,
  ) async {
    switch (bucket) {
      case ExtraPracticeBucket.tomorrow:
        return wordProgressRepository.getTomorrowProgressAsync(
          detailedType,
          limit,
        );
      case ExtraPracticeBucket.recentlyLearned:
        return wordProgressRepository.getRecentlyLearnedProgressAsync(
          detailedType,
          limit,
        );
      case ExtraPracticeBucket.random:
        return wordProgressRepository.getRandomProgressAsync(
          detailedType,
          limit,
        );
      case ExtraPracticeBucket.weakest:
        return wordProgressRepository.getWeakestProgressAsync(
          detailedType,
          limit,
        );
    }
  }

  /// Computes which [ExerciseTypeDetailed] are currently unlocked for each
  /// word in [wordIds] based on their existing progress records.
  ///
  /// Words with no progress records only unlock types that have no
  /// prerequisite (e.g. [ExerciseTypeDetailed.flipCardDutchEnglish]).
  @visibleForTesting
  static Map<int, Set<ExerciseTypeDetailed>> computeUnlockedTypesPerWord(
    List<int> wordIds,
    Map<int, List<DbWordProgress>> progressByWordId,
  ) {
    return {
      for (final id in wordIds)
        id: ExerciseTypeOrder.unlockedTypesForWord({
          for (final p in (progressByWordId[id] ?? []))
            p.exerciseType:
                p.scheduledPracticeCorrectAnswerStreak +
                p.customPracticeCorrectAnswerStreak,
        }),
    };
  }

  QuickPracticeSession _createSession({
    required List<Word> words,
    required List<ExerciseType> activeTypes,
    required SessionSettings sessionSettings,
    required WordProgressService wordProgressService,
    required ExerciseAnsweredNotifier notifier,
    Map<int, Set<ExerciseTypeDetailed>>? unlockedTypesById,
  }) {
    final flowManager = LearningSessionManager(
      activeTypes,
      words,
      wordProgressService,
      notifier,
      useAnkiMode: sessionSettings.useAnkiMode,
      includePhrasesInWriting: sessionSettings.includePhrasesInWriting,
      unlockedTypesById: unlockedTypesById,
    );

    return QuickPracticeSession(
      flowManager: flowManager,
      showPreSessionWordList: sessionSettings.showPreSessionWordList,
    );
  }
}
