import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/services/exercise_unlock_service.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'exercise_unlock_service_test.mocks.dart';

// re-generate with: dart run build_runner build --delete-conflicting-outputs
@GenerateMocks([WordProgressBatchRepository])
void main() {
  // ── helpers ──────────────────────────────────────────────────────────────

  Word _noun(int id, {String dutch = 'word'}) => Word(
    id,
    dutch,
    ['translation'],
    PartOfSpeech.noun,
    nounDetails: WordNounDetails(),
    verbDetails: null,
  );

  /// Builds a [DbWordProgress] suitable for pure-dart tests (no Isar link).
  DbWordProgress _progress(
    ExerciseTypeDetailed type, {
    int consecutiveCorrect = 0,
  }) {
    final p = DbWordProgress();
    p.exerciseType = type;
    p.consequetiveCorrectAnswers = consecutiveCorrect;
    return p;
  }

  late MockWordProgressBatchRepository mockRepo;
  late ExerciseUnlockService service;

  setUp(() {
    mockRepo = MockWordProgressBatchRepository();
    service = ExerciseUnlockService(repository: mockRepo);
  });

  // ── snapshotUnlockedTypesAsync ───────────────────────────────────────────

  group('snapshotUnlockedTypesAsync', () {
    test(
      'brand-new word (empty progress) → only flipCardDutchEnglish',
      () async {
        when(
          mockRepo.getProgressByWordIdAsync([1]),
        ).thenAnswer((_) async => {1: <DbWordProgress>[]});

        final result = await service.snapshotUnlockedTypesAsync([1]);

        expect(result[1], {ExerciseTypeDetailed.flipCardDutchEnglish});
      },
    );

    test(
      '1 consecutive correct → flipCardDutchEnglish + flipCardEnglishDutch',
      () async {
        when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
          (_) async => {
            1: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 1,
              ),
            ],
          },
        );

        final result = await service.snapshotUnlockedTypesAsync([1]);

        expect(
          result[1],
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          ]),
        );
        expect(result[1], isNot(contains(ExerciseTypeDetailed.basicWrite)));
      },
    );

    test('3 consecutive correct → all three types unlocked', () async {
      when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
        (_) async => {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 3,
            ),
          ],
        },
      );

      final result = await service.snapshotUnlockedTypesAsync([1]);

      expect(
        result[1],
        containsAll([
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
          ExerciseTypeDetailed.basicWrite,
        ]),
      );
    });
  });

  // ── computeAndPersistNewUnlocksAsync ─────────────────────────────────────

  group('computeAndPersistNewUnlocksAsync', () {
    test('returns empty when words list is empty', () async {
      final result = await service.computeAndPersistNewUnlocksAsync(
        words: [],
        preSessionUnlocked: {},
      );
      expect(result, isEmpty);
    });

    test('no change in consecutive correct → no new unlocks', () async {
      final word = _noun(1);
      // pre-session: consecutive=0 → only flipCardDutchEnglish
      const pre = {
        1: {ExerciseTypeDetailed.flipCardDutchEnglish},
      };
      // post-session: still consecutive=0
      when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
        (_) async => {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 0,
            ),
          ],
        },
      );

      final result = await service.computeAndPersistNewUnlocksAsync(
        words: [word],
        preSessionUnlocked: pre,
      );

      expect(result, isEmpty);
    });

    test('consecutive goes 0→1: flipCardEnglishDutch newly unlocked', () async {
      final word = _noun(1);
      const pre = {
        1: {ExerciseTypeDetailed.flipCardDutchEnglish},
      };
      // post-session: consecutive=1
      when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
        (_) async => {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 1,
            ),
          ],
        },
      );
      when(mockRepo.getOrCreateManyAsync(any)).thenAnswer((_) async => {});

      final result = await service.computeAndPersistNewUnlocksAsync(
        words: [word],
        preSessionUnlocked: pre,
      );

      expect(result.length, 1);
      expect(result.first.word.id, 1);
      expect(
        result.first.newlyUnlocked,
        contains(ExerciseTypeDetailed.flipCardEnglishDutch),
      );
    });

    test('consecutive goes 2→3: basicWrite newly unlocked', () async {
      final word = _noun(1);
      // pre: 2 consecutive → flipCardDutchEnglish + flipCardEnglishDutch
      final pre = {
        1: {
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
        },
      };
      // post: consecutive=3
      when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
        (_) async => {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 3,
            ),
          ],
        },
      );
      when(mockRepo.getOrCreateManyAsync(any)).thenAnswer((_) async => {});

      final result = await service.computeAndPersistNewUnlocksAsync(
        words: [word],
        preSessionUnlocked: pre,
      );

      expect(result.length, 1);
      expect(result.first.newlyUnlocked, [ExerciseTypeDetailed.basicWrite]);
    });

    test('already at 3 consecutive before session → no new unlocks', () async {
      final word = _noun(1);
      // pre: already all three unlocked
      final pre = {
        1: {
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
          ExerciseTypeDetailed.basicWrite,
        },
      };
      // post: still 3+ consecutive
      when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
        (_) async => {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 4,
            ),
          ],
        },
      );

      final result = await service.computeAndPersistNewUnlocksAsync(
        words: [word],
        preSessionUnlocked: pre,
      );

      expect(
        result,
        isEmpty,
        reason: 'already-unlocked types must not be reported again',
      );
    });

    test(
      'multiple words: only words with new unlocks appear in result',
      () async {
        final word1 = _noun(1); // will unlock flipCardEnglishDutch
        final word2 = _noun(2); // no change
        final word3 = _noun(3); // will unlock basicWrite

        final pre = {
          1: {ExerciseTypeDetailed.flipCardDutchEnglish},
          2: {ExerciseTypeDetailed.flipCardDutchEnglish},
          3: {
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          },
        };

        when(mockRepo.getProgressByWordIdAsync([1, 2, 3])).thenAnswer(
          (_) async => {
            1: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 1,
              ),
            ],
            2: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 0,
              ),
            ],
            3: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 3,
              ),
            ],
          },
        );
        when(mockRepo.getOrCreateManyAsync(any)).thenAnswer((_) async => {});

        final result = await service.computeAndPersistNewUnlocksAsync(
          words: [word1, word2, word3],
          preSessionUnlocked: pre,
        );

        expect(result.length, 2);
        final ids = result.map((r) => r.word.id).toSet();
        expect(ids, containsAll([1, 3]));
        expect(ids, isNot(contains(2)));

        final r1 = result.firstWhere((r) => r.word.id == 1);
        expect(r1.newlyUnlocked, [ExerciseTypeDetailed.flipCardEnglishDutch]);

        final r3 = result.firstWhere((r) => r.word.id == 3);
        expect(r3.newlyUnlocked, [ExerciseTypeDetailed.basicWrite]);
      },
    );

    test(
      'mistake resets consecutive → no new unlocks even if pre was low',
      () async {
        final word = _noun(1);
        // pre: consecutive=2 → flipCard + flipCardEnglishDutch
        final pre = {
          1: {
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          },
        };
        // post: mistake reset consecutive to 0
        when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
          (_) async => {
            1: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 0,
              ),
            ],
          },
        );

        final result = await service.computeAndPersistNewUnlocksAsync(
          words: [word],
          preSessionUnlocked: pre,
        );

        // flipCardEnglishDutch was already unlocked pre-session, nothing new
        expect(result, isEmpty);
      },
    );

    test(
      'mistake resets consecutive but existing record keeps it unlocked in next snapshot',
      () async {
        // After a mistake, consecutive resets to 0. But the DB record for
        // flipCardEnglishDutch still exists, so the snapshot should still
        // show it as unlocked (progressByType.containsKey check).
        when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
          (_) async => {
            1: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 0,
              ),
              // Record for flipCardEnglishDutch exists → stays unlocked.
              _progress(
                ExerciseTypeDetailed.flipCardEnglishDutch,
                consecutiveCorrect: 0,
              ),
            ],
          },
        );

        final result = await service.snapshotUnlockedTypesAsync([1]);

        expect(
          result[1],
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          ]),
          reason:
              'Record exists for flipCardEnglishDutch so it must stay unlocked',
        );
      },
    );

    test(
      'all types have records but consecutive is 0 everywhere → all stay unlocked',
      () async {
        when(mockRepo.getProgressByWordIdAsync([1])).thenAnswer(
          (_) async => {
            1: [
              _progress(
                ExerciseTypeDetailed.flipCardDutchEnglish,
                consecutiveCorrect: 0,
              ),
              _progress(
                ExerciseTypeDetailed.flipCardEnglishDutch,
                consecutiveCorrect: 0,
              ),
              _progress(ExerciseTypeDetailed.basicWrite, consecutiveCorrect: 0),
            ],
          },
        );

        final result = await service.snapshotUnlockedTypesAsync([1]);

        expect(
          result[1],
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
          ]),
          reason: 'DB records exist for all types → none can be re-locked',
        );
      },
    );
  });
}
