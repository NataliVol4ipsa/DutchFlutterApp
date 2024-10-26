import 'package:flutter/material.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/pages/words_editor/word_editor_page.dart';

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
