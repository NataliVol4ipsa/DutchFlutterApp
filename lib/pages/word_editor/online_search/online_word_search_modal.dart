import 'package:dutch_app/pages/word_editor/online_search/online_word_search_page.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

class OnlineWordSearchModal {
  static Future<void> show(BuildContext context, String word) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(BorderStyles.bigBorderRadiusValue)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: OnlineWordSearchPage(word: word),
        );
      },
    );
  }
}
