import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/services/audio_dictation_service.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stand-in for [WordProgressBatchRepository]. Only the two methods
/// used by [AudioDictationService.pruneStaleSchedulesAsync] are overridden.
class _FakeBatchRepository extends WordProgressBatchRepository {
  final List<DbWordProgress> records;
  List<DbWordProgress> savedRecords = const [];

  _FakeBatchRepository(this.records) : super(WordProgressRepository());

  @override
  Future<List<DbWordProgress>> getAllByTypeAsync(
    ExerciseTypeDetailed exerciseType,
  ) async => records;

  @override
  Future<void> saveAllAsync(List<DbWordProgress> progressList) async {
    savedRecords = progressList;
  }
}

Word _word({int id = 1, String dutch = 'hond'}) => Word(
  id,
  dutch,
  ['dog'],
  PartOfSpeech.noun,
  nounDetails: null,
  verbDetails: null,
);

DbWordProgress _audioProgress({
  required String dutch,
  DateTime? lastReview,
  bool dontShowAgain = false,
}) {
  final dutchWord = DbDutchWord()..word = dutch;
  final dbWord = DbWord()..type = PartOfSpeech.noun;
  dbWord.dutchWordLink.value = dutchWord;

  final progress = DbWordProgress()
    ..exerciseType = ExerciseTypeDetailed.audioDictation
    ..lastReviewDate = lastReview
    ..dontShowAgain = dontShowAgain;
  progress.word.value = dbWord;
  return progress;
}

void main() {
  group('AudioDictationService.eligibleWordIdsAsync', () {
    test('returns only ids of words whose audio is cached', () async {
      final cached = {'hond'};
      final service = AudioDictationService(
        wordProgressRepository: _FakeBatchRepository(const []),
        hasCachedAudio: (w) async => cached.contains(w),
      );

      final ids = await service.eligibleWordIdsAsync([
        _word(id: 1, dutch: 'hond'),
        _word(id: 2, dutch: 'kat'),
      ]);

      expect(ids, {1});
    });
  });

  group('AudioDictationService.pruneStaleSchedulesAsync', () {
    final now = DateTime(2026, 1, 1);

    test(
      'unschedules words without audio not reviewed for over a year',
      () async {
        final stale = _audioProgress(
          dutch: 'hond',
          lastReview: now.subtract(const Duration(days: 400)),
        );
        final recentlyMissing = _audioProgress(
          dutch: 'kat',
          lastReview: now.subtract(const Duration(days: 100)),
        );
        final stillCached = _audioProgress(
          dutch: 'huis',
          lastReview: now.subtract(const Duration(days: 400)),
        );
        final alreadyPruned = _audioProgress(
          dutch: 'boom',
          lastReview: now.subtract(const Duration(days: 800)),
          dontShowAgain: true,
        );

        final repo = _FakeBatchRepository([
          stale,
          recentlyMissing,
          stillCached,
          alreadyPruned,
        ]);
        final service = AudioDictationService(
          wordProgressRepository: repo,
          // Only "huis" still has cached audio.
          hasCachedAudio: (w) async => w == 'huis',
        );

        final pruned = await service.pruneStaleSchedulesAsync(now: now);

        expect(pruned, 1);
        expect(stale.dontShowAgain, isTrue);
        expect(recentlyMissing.dontShowAgain, isFalse);
        expect(stillCached.dontShowAgain, isFalse);
        expect(repo.savedRecords, [stale]);
      },
    );

    test('does nothing when every word still has cached audio', () async {
      final progress = _audioProgress(
        dutch: 'hond',
        lastReview: now.subtract(const Duration(days: 400)),
      );
      final repo = _FakeBatchRepository([progress]);
      final service = AudioDictationService(
        wordProgressRepository: repo,
        hasCachedAudio: (_) async => true,
      );

      final pruned = await service.pruneStaleSchedulesAsync(now: now);

      expect(pruned, 0);
      expect(progress.dontShowAgain, isFalse);
      expect(repo.savedRecords, isEmpty);
    });
  });
}
