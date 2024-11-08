import 'package:flutter/material.dart';

class LearningTaskAnsweredNotifier extends ChangeNotifier {
  bool isAnswered = false;

  void updateAnswer(bool isAnsweredData) {
    isAnswered = isAnsweredData;
    notifyListeners();
  }
}
