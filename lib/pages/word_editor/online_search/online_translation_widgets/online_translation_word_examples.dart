import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/translation_card_section_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordExamples extends StatelessWidget {
  const OnlineTranslationWordExamples({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  List<Widget> _generateSentenceExamples(
      DutchToEnglishTranslation translation) {
    return translation.sentenceExamples
        .map((example) => _generateSentenceExample(example))
        .toList();
  }

  Widget _generateSentenceExample(SentenceExample example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 48,
              child: _generateSentenceExampleText(example.dutchSentence)),
          Expanded(flex: 4, child: Container()),
          Expanded(
              flex: 48,
              child: _generateSentenceExampleText(example.englishSentence)),
        ],
      ),
    );
  }

  Widget _generateSentenceExampleText(String inputString) {
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

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (translation.sentenceExamples.isNotEmpty) ...[
        const SizedBox(height: 10),
        TranslationCardSection(
            name: 'Examples',
            icon: InputIcons.contextExample,
            child: Column(
              children: _generateSentenceExamples(translation),
            )),
      ],
    ]);
  }
}
