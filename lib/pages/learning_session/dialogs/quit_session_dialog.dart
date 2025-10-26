import 'package:dutch_app/reusable_widgets/modals/confirmation_modal_widget.dart';
import 'package:flutter/material.dart';

void showQuitSessionDialog({
  required BuildContext context,
  required VoidCallback onQuit,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationModal(
        title: 'Quit learning session?',
        description: 'Current progress will be lost.',
        confirmButtonText: 'QUIT',
        onConfirmPressed: (context) async {
          onQuit();
        },
      );
    },
  );
}
