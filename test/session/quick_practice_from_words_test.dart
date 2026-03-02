import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/models/exercise_mode_quota.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'quick_practice_from_words_test.mocks.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

Word _noun(int id) => Word(
  id,
  'word$id',
  ['translation$id'],
  PartOfSpeech.noun,
  nounDetails: WordNounDetails(),
  verbDetails: null,
);

Settings _settings({int newWords = 5, int repetitions = 10}) => Settings(
  theme: ThemeSettings(),
  session: SessionSettings(
    newWordsPerSession: newWords,
    repetitionsPerSession: repetitions,
  ),
);

// ── mocks ─────────────────────────────────────────────────────────────────────
// Re-run `dart run build_runner build --delete-conflicting-outputs` after
// adding or removing from this list.
@GenerateMocks([
  SettingsService,
  WordProgressBatchRepository,
  WordsRepository,
  WordProgressService,
])
void main() {
  late MockSettingsService mockSettings;
  late MockWordProgressBatchRepository mockRepo;
  late MockWordsRepository mockWordsRepository;
  late MockWordProgressService mockWordProgressService;
  late ExerciseAnsweredNotifier notifier;
  late QuickPracticeService service;

  setUp(() {
    mockSettings = MockSettingsService();
    mockRepo = MockWordProgressBatchRepository();
    mockWordsRepository = MockWordsRepository();
    mockWordProgressService = MockWordProgressService();
    notifier = ExerciseAnsweredNotifier();

    service = QuickPracticeService(
      wordsRepository: mockWordsRepository,
      wordProgressRepository: mockRepo,
      settingsService: mockSettings,
      quota: ExerciseModeQuota.flipCardOnly,
    );
  });

  tearDown(() => notifier.dispose());

  // ── buildSessionFromWordsAsync – daily new-word quota ─────────────────────

  group('buildSessionFromWordsAsync – daily new-word quota', () {
    test(
      'first session of the day: takes up to newWordsPerSession new words',
      () async {
        // 0 new words introduced today → full daily quota of 5 available.
        // User selected 10 words; none practiced yet.
        when(
          mockSettings.getSettingsAsync(),
        ).thenAnswer((_) async => _settings(newWords: 5, repetitions: 10));
        when(
          mockRepo.countNewWordsIntroducedTodayAsync(),
        ).thenAnswer((_) async => 0);
        when(
          mockWordProgressService.getPracticedWordIdsAsync(any),
        ).thenAnswer((_) async => {}); // none practiced
        when(
          mockRepo.getProgressByWordIdAsync(any),
        ).thenAnswer((_) async => {});

        final words = List.generate(10, _noun);

        final session = await service.buildSessionFromWordsAsync(
          words: words,
          wordProgressService: mockWordProgressService,
          notifier: notifier,
        );

        // Only 5 new words should be taken (newWordsPerSession cap).
        expect(session.flowManager.words.length, 5);
      },
    );

    test(
      'second session of the day (quota exhausted): no new words, only review',
      () async {
        // Daily quota of 5 already consumed by an earlier session.
        when(
          mockSettings.getSettingsAsync(),
        ).thenAnswer((_) async => _settings(newWords: 5, repetitions: 10));
        when(
          mockRepo.countNewWordsIntroducedTodayAsync(),
        ).thenAnswer((_) async => 5); // quota fully used

        final words = List.generate(10, _noun);
        // Words 0-4 are practiced (review); words 5-9 are new but quota is zero.
        final practicedIds = {0, 1, 2, 3, 4};
        when(
          mockWordProgressService.getPracticedWordIdsAsync(any),
        ).thenAnswer((_) async => practicedIds);
        when(
          mockRepo.getProgressByWordIdAsync(any),
        ).thenAnswer((_) async => {});

        final session = await service.buildSessionFromWordsAsync(
          words: words,
          wordProgressService: mockWordProgressService,
          notifier: notifier,
        );

        // 5 review words; 0 new words (quota = 5 - 5 = 0).
        expect(session.flowManager.words.length, 5);
        final sessionIds = session.flowManager.words.map((w) => w.id).toSet();
        for (final id in [5, 6, 7, 8, 9]) {
          expect(
            sessionIds,
            isNot(contains(id)),
            reason: 'word $id is new and daily quota is exhausted',
          );
        }
      },
    );

    test(
      'partial quota remaining: only remaining slots go to new words',
      () async {
        // 3 out of 5 new-word slots already used today → 2 remaining.
        when(
          mockSettings.getSettingsAsync(),
        ).thenAnswer((_) async => _settings(newWords: 5, repetitions: 10));
        when(
          mockRepo.countNewWordsIntroducedTodayAsync(),
        ).thenAnswer((_) async => 3); // 2 slots remaining

        // All 6 selected words are brand new.
        final words = List.generate(6, _noun);
        when(
          mockWordProgressService.getPracticedWordIdsAsync(any),
        ).thenAnswer((_) async => {});
        when(
          mockRepo.getProgressByWordIdAsync(any),
        ).thenAnswer((_) async => {});

        final session = await service.buildSessionFromWordsAsync(
          words: words,
          wordProgressService: mockWordProgressService,
          notifier: notifier,
        );

        // 5 - 3 = 2 remaining new-word slots.
        expect(session.flowManager.words.length, 2);
      },
    );

    test(
      'throws when quota is zero and selected words contain no review words',
      () async {
        when(
          mockSettings.getSettingsAsync(),
        ).thenAnswer((_) async => _settings(newWords: 5));
        when(
          mockRepo.countNewWordsIntroducedTodayAsync(),
        ).thenAnswer((_) async => 5); // quota exhausted

        final words = List.generate(4, _noun); // all new, no review
        when(
          mockWordProgressService.getPracticedWordIdsAsync(any),
        ).thenAnswer((_) async => {});
        when(
          mockRepo.getProgressByWordIdAsync(any),
        ).thenAnswer((_) async => {});

        expect(
          () => service.buildSessionFromWordsAsync(
            words: words,
            wordProgressService: mockWordProgressService,
            notifier: notifier,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
