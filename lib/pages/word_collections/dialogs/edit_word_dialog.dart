import 'package:dutch_app/pages/word_editor/word_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/core/models/word.dart';

class EditWordDialog {
  static Future<void> show({
    required BuildContext context,
    required Word word,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: WordEditorPage(existingWordId: word.id),
        );
      },
    );
  }
}
