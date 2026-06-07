import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/audio_dictation/audio_dictation_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:flutter/material.dart';

/// Listening exercise: the Dutch audio is played and the user writes the word
/// they heard. Only words whose audio is cached on the device are eligible —
/// this structural check just guards against blank words; the cached-audio
/// gate is applied by the generator via the pre-computed eligible id set.
class AudioDictationExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.audioDictation;

  final Word word;
  late final String? hint;

  bool _isAnswered = false;

  AudioDictationExercise(this.word) : super(requiredWords, type) {
    hint = word.partOfSpeech != PartOfSpeech.unspecified
        ? word.partOfSpeech.name
        : null;
  }

  /// Structural eligibility. The audio-cache requirement is enforced separately
  /// by the generator, which only builds this exercise for words known to have
  /// a cached audio file.
  static bool isSupportedWord(Word word) {
    return word.dutchWord.trim().isNotEmpty;
  }

  void processAnswer(bool isCorrect) {
    _isAnswered = true;
    if (isCorrect) {
      answerSummary.totalCorrectAnswers++;
    } else {
      answerSummary.totalWrongAnswers++;
    }
  }

  @override
  bool isAnswered() => _isAnswered;

  @override
  Widget buildWidget({
    Key? key,
    required Future<void> Function() onNextButtonPressed,
    required String nextButtonText,
  }) {
    return AudioDictationExerciseWidget(
      this,
      key: key,
      onNextButtonPressed: onNextButtonPressed,
      nextButtonText: nextButtonText,
    );
  }

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
        word: word,
        exerciseType: ExerciseType.audioDictation,
        totalCorrectAnswers: answerSummary.totalCorrectAnswers,
        totalWrongAnswers: answerSummary.totalWrongAnswers,
        correctAnswer: word.dutchWord,
      ),
    ];
  }

  /// Validates user input the same way the writing exercise does: exact match
  /// or a single-character typo (Levenshtein distance of 1) both count as
  /// correct.
  static AudioDictationResult evaluateInput(String input, String correct) {
    final normalised = WriteExercise.normaliseInput(input);
    if (normalised.toLowerCase() == correct.toLowerCase()) {
      return AudioDictationResult.correct;
    }
    final distance = WriteExercise.levenshteinDistance(normalised, correct);
    if (distance == 1) {
      return AudioDictationResult.nearCorrect;
    }
    return AudioDictationResult.wrong;
  }
}

enum AudioDictationResult { correct, nearCorrect, wrong }
