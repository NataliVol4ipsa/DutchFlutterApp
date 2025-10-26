import 'package:flutter/material.dart';

class OnlineWordSearchErrorNotifier extends ChangeNotifier {
  int? errorStatusCode;
  String? errorMesssage;
  bool get hasError => errorMesssage != null || errorStatusCode != null;

  void notifyOccurred({int? errorStatusCode, String? errorMesssage}) {
    this.errorStatusCode = errorStatusCode;
    this.errorMesssage = errorMesssage;
    notifyListeners();
  }

  void reset() {
    errorStatusCode = null;
    errorMesssage = null;
  }
}
