import 'package:dutch_app/core/audio/word_audio_service.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:flutter/foundation.dart';

/// Resolves the cached-audio status of a Dutch word. Injectable so tests can
/// avoid touching the file system.
typedef HasCachedAudio = Future<bool> Function(String dutchWord);

/// Encapsulates the audio-dictation specific rules:
/// - which words are eligible (audio is cached on the device), and
/// - pruning of stale schedules for words whose audio is no longer cached.
class AudioDictationService {
  /// Words whose audio has been missing for at least this long stop being
  /// scheduled for review.
  static const Duration staleThreshold = Duration(days: 365);

  final WordProgressBatchRepository wordProgressRepository;
  final HasCachedAudio hasCachedAudio;

  AudioDictationService({
    required this.wordProgressRepository,
    HasCachedAudio? hasCachedAudio,
  }) : hasCachedAudio = hasCachedAudio ?? WordAudioService.hasCachedAudio;

  /// Returns the ids of [words] that currently have a cached audio file and are
  /// therefore eligible for audio dictation.
  Future<Set<int>> eligibleWordIdsAsync(List<Word> words) async {
    final results = await Future.wait(
      words.map((word) async {
        final has = await hasCachedAudio(word.dutchWord);
        return has ? word.id : null;
      }),
    );
    return results.whereType<int>().toSet();
  }

  /// Walks every audio-dictation progress record and, for words whose audio is
  /// no longer cached, unschedules those that have not been reviewed within
  /// [staleThreshold] (default one year). Returns the number of pruned records.
  ///
  /// Words that simply lost their audio temporarily keep their schedule and are
  /// skipped at session-composition time; only the long-untouched ones are
  /// permanently dropped from scheduling here.
  Future<int> pruneStaleSchedulesAsync({DateTime? now}) async {
    final reference = now ?? DateTime.now();
    final records = await wordProgressRepository.getAllByTypeAsync(
      ExerciseTypeDetailed.audioDictation,
    );

    final toPrune = <DbWordProgress>[];
    for (final record in records) {
      if (record.dontShowAgain) continue;
      final dutchWord = record.word.value?.dutchWordLink.value?.word;
      if (dutchWord == null) continue;
      if (await hasCachedAudio(dutchWord)) continue;

      final lastTouched = record.lastReviewDate ?? record.lastPracticed;
      if (lastTouched == null) continue;
      if (reference.difference(lastTouched) >= staleThreshold) {
        record.dontShowAgain = true;
        toPrune.add(record);
      }
    }

    if (toPrune.isNotEmpty) {
      await wordProgressRepository.saveAllAsync(toPrune);
    }
    return toPrune.length;
  }

  @visibleForTesting
  static bool isStale(DbWordProgress record, DateTime now) {
    final lastTouched = record.lastReviewDate ?? record.lastPracticed;
    if (lastTouched == null) return false;
    return now.difference(lastTouched) >= staleThreshold;
  }
}
