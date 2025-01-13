import 'package:flutter/material.dart';

class SnackbarShower {
  late ScaffoldMessengerState messenger;

  SnackbarShower(BuildContext context) {
    messenger = ScaffoldMessenger.of(context);
  }

  void show(String message, {int durationSeconds = 3}) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
