import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:flutter/material.dart';

class SentenceExampleText extends StatelessWidget {
  const SentenceExampleText({
    super.key,
    required this.inputString,
  });

  final String inputString;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'<span class="hl">(.*?)<\/span>');
    int currentIndex = 0;

    for (final match in regex.allMatches(inputString)) {
      // Add the normal text before the match
      if (match.start > currentIndex) {
        spans.add(
            TextSpan(text: inputString.substring(currentIndex, match.start)));
      }

      // Add the bolded span
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

      currentIndex = match.end;
    }

    // Add any trailing text after the last match
    if (currentIndex < inputString.length) {
      spans.add(TextSpan(text: inputString.substring(currentIndex)));
    }
    return SelectableText.rich(TextSpan(
      children: spans,
      style: TextStyle(
        fontSize: OnlineTranslationFonts.sectionContentFontSize,
      ),
    ));
  }
}
