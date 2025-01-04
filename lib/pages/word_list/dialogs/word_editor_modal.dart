import 'package:flutter/material.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/pages/word_editor/word_editor_page.dart';

class WordEditorModal {
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
          child: WordEditorPage(existingWord: word),
        );
      },
    );
  }
}
