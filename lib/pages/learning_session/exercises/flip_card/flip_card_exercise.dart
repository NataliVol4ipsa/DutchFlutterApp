import 'package:first_project/pages/learning_session/exercises/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/exercise_type.dart';
import 'package:flutter/material.dart';

class FlipCardExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.flipCard;
  final Word word;

  FlipCardExercise(this.word) : super(requiredWords, type);

  static bool isSupportedWord(Word word) {
    return true;
  }

  @override
  Widget buildWidget({Key? key}) {
    // TODO: implement buildWidget
    throw UnimplementedError();
  }

  @override
  bool isAnswered() {
    // TODO: implement isAnswered
    throw UnimplementedError();
  }
}
