import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result_sentence_example.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/translation_card_section_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/sentence_example_text_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordExamples extends StatefulWidget {
  final TranslationSearchResult translation;
  final int maxVisible;

  const OnlineTranslationWordExamples({
    super.key,
    required this.translation,
    required this.maxVisible,
  });

  @override
  State<OnlineTranslationWordExamples> createState() =>
      _OnlineTranslationWordExamplesState();
}

class _OnlineTranslationWordExamplesState
    extends State<OnlineTranslationWordExamples> {
  bool _isExpanded = false;

  List<Widget> _generateSentenceExamples(TranslationSearchResult translation) {
    final visibleTranslations = _isExpanded
        ? translation.sentenceExamples
        : translation.sentenceExamples.take(widget.maxVisible).toList();

    return visibleTranslations
        .map((example) => _generateSentenceExample(example))
        .toList();
  }

  Widget _generateSentenceExample(
      TranslationSearchResultSentenceExample example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 48,
              child: SentenceExampleText(inputString: example.dutchSentence)),
          Expanded(flex: 4, child: Container()),
          Expanded(
              flex: 48,
              child: SentenceExampleText(inputString: example.englishSentence)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int hiddenCount =
        widget.translation.sentenceExamples.length - widget.maxVisible;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.translation.sentenceExamples.isNotEmpty) ...[
        const SizedBox(height: 10),
        TranslationCardSection(
            name: 'Examples',
            icon: InputIcons.contextExample,
            child: Column(
              children: _generateSentenceExamples(widget.translation),
            )),
      ],
      if (hiddenCount > 0)
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ContainerStyles.defaultPaddingAmount * 2),
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                _isExpanded ? "show less" : "+$hiddenCount more",
                style: TextStyle(
                  color: BaseStyles.getColorScheme(context).secondary,
                  fontSize: OnlineTranslationFonts.sectionTooltipFontSize,
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
