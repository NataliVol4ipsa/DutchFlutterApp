import 'package:flutter/material.dart';

class ExerciseAnsweredNotifier extends ChangeNotifier {
  bool isAnswered = false;

  void notifyAnswerUpdated(bool isAnsweredData) {
    isAnswered = isAnsweredData;
    notifyListeners();
  }

  void reset() {
    isAnswered = false;
  }
}
