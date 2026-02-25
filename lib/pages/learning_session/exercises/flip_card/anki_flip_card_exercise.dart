import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/anki_flip_card_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

class AnkiFlipCardExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.flipCard;
  final Word word;

  late String inputWord;
  late String correctAnswer;
  late String? hint;

  AnkiGrade? chosenGrade;

  AnkiFlipCardExercise(this.word) : super(requiredWords, type) {
    inputWord = word.dutchWord;
    if (word.nounDetails?.deHetType != null &&
        word.nounDetails?.deHetType != DeHetType.none &&
        word.partOfSpeech == PartOfSpeech.noun) {
      inputWord = "${word.nounDetails!.deHetType.label} $inputWord";
    }
    correctAnswer = SemicolonWordsConverter.toSingleString(word.englishWords);
    hint = word.partOfSpeech != PartOfSpeech.unspecified
        ? word.partOfSpeech.name
        : null;
  }

  static bool isSupportedWord(Word word) => true;

  void processAnswer(AnkiGrade grade) {
    chosenGrade = grade;
    if (grade.isMistake) {
      answerSummary.totalWrongAnswers++;
    } else {
      answerSummary.totalCorrectAnswers++;
    }
  }

  @override
  Widget buildWidget({
    Key? key,
    required Future<void> Function() onNextButtonPressed,
    required String nextButtonText,
  }) {
    return AnkiFlipCardExerciseWidget(
      this,
      key: key,
      onNextButtonPressed: onNextButtonPressed,
      nextButtonText: nextButtonText,
    );
  }

  @override
  bool isAnswered() => chosenGrade != null;

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
        word: word,
        exerciseType: ExerciseType.flipCard,
        totalCorrectAnswers: answerSummary.totalCorrectAnswers,
        totalWrongAnswers: answerSummary.totalWrongAnswers,
        correctAnswer:
            "${word.toDutchWordString()} - ${SemicolonWordsConverter.toSingleString(word.englishWords)}",
        ankiGrade: chosenGrade,
      ),
    ];
  }
}
