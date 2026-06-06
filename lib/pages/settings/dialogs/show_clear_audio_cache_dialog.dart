import 'package:dutch_app/core/audio/word_audio_service.dart';
import 'package:dutch_app/reusable_widgets/modals/confirmation_modal_widget.dart';
import 'package:flutter/material.dart';

void showClearAudioCacheDialog({
  required BuildContext context,
  required Future<void> Function() callback,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationModal(
        title: 'Clear audio cache?',
        description:
            'This will delete all downloaded word audio from this device.',
        confirmButtonText: 'CLEAR',
        onConfirmPressed: (context) async {
          await _clearCacheAsync(callback);
        },
      );
    },
  );
}

Future<void> _clearCacheAsync(Future<void> Function() callback) async {
  await WordAudioService.clearCache();
  await callback();
}
