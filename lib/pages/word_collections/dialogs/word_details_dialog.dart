import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/pages/word_collections/word_details/word_details_widget.dart';
import 'package:flutter/material.dart';

class WordDetailsDialog {
  static Future<void> show(
      {required BuildContext context,
      required Word word,
      Future<void> Function()? deletionCallback}) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: WordDetails(
            word: word,
            deletionCallback: deletionCallback,
          ),
        );
      },
    );
  }
}
