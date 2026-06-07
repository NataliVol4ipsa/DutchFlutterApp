import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/exercises/audio_dictation/audio_dictation_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

Word _word({
  int id = 1,
  String dutch = 'hond',
  PartOfSpeech pos = PartOfSpeech.noun,
}) => Word(id, dutch, ['dog'], pos, nounDetails: null, verbDetails: null);

void main() {
  group('AudioDictationExercise.isSupportedWord', () {
    test('supported when the Dutch word is non-empty', () {
      expect(AudioDictationExercise.isSupportedWord(_word()), isTrue);
    });

    test('not supported when the Dutch word is blank', () {
      expect(
        AudioDictationExercise.isSupportedWord(_word(dutch: '   ')),
        isFalse,
      );
    });
  });

  group('AudioDictationExercise.hint', () {
    test('is null when part of speech is unspecified', () {
      final exercise = AudioDictationExercise(
        _word(pos: PartOfSpeech.unspecified),
      );
      expect(exercise.hint, isNull);
    });

    test('equals the part-of-speech name otherwise', () {
      final exercise = AudioDictationExercise(_word(pos: PartOfSpeech.noun));
      expect(exercise.hint, PartOfSpeech.noun.name);
    });
  });

  group('AudioDictationExercise.evaluateInput', () {
    test('exact match (case/space insensitive) is correct', () {
      expect(
        AudioDictationExercise.evaluateInput('  Hond ', 'hond'),
        AudioDictationResult.correct,
      );
    });

    test('single typo is treated as near-correct', () {
      expect(
        AudioDictationExercise.evaluateInput('bond', 'hond'),
        AudioDictationResult.nearCorrect,
      );
    });

    test('two or more differences are wrong', () {
      expect(
        AudioDictationExercise.evaluateInput('kat', 'hond'),
        AudioDictationResult.wrong,
      );
    });
  });

  group('AudioDictationExercise answer tracking', () {
    test('processAnswer marks answered and counts a correct answer', () {
      final exercise = AudioDictationExercise(_word());
      expect(exercise.isAnswered(), isFalse);

      exercise.processAnswer(true);

      expect(exercise.isAnswered(), isTrue);
      expect(exercise.answerSummary.totalCorrectAnswers, 1);
      expect(exercise.answerSummary.totalWrongAnswers, 0);
    });

    test('processAnswer counts a wrong answer', () {
      final exercise = AudioDictationExercise(_word());
      exercise.processAnswer(false);
      expect(exercise.answerSummary.totalWrongAnswers, 1);
    });

    test('generateSummaries stamps the audio-dictation type and answer', () {
      final exercise = AudioDictationExercise(_word(dutch: 'huis'));
      exercise.processAnswer(true);

      final summaries = exercise.generateSummaries();
      expect(summaries, hasLength(1));
      expect(summaries.single.exerciseType, ExerciseType.audioDictation);
      expect(summaries.single.correctAnswer, 'huis');
      expect(summaries.single.totalCorrectAnswers, 1);
    });
  });
}
