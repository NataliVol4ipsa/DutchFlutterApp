import 'package:flutter/material.dart';

class WordCreatedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
