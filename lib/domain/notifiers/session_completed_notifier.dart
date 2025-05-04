import 'package:flutter/material.dart';

class SessionCompletedNotifier extends ChangeNotifier {
  bool isCompleted = false;

  void notifyCompleted() {
    isCompleted = true;
    notifyListeners();
  }

  void reset() {
    isCompleted = false;
  }
}
