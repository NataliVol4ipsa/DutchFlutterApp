import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/http_clients/vertalennu/models/online_translation_dutch_word.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/translation_card_section_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordSynonyms extends StatelessWidget {
  const OnlineTranslationWordSynonyms({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  List<TextSpan> _generateDutchTextSpans(
      DutchToEnglishTranslation translation) {
    final List<OnlineTranslationDutchWord> words = translation.synonyms;

    return List<TextSpan>.generate(words.length, (i) {
      final isLast = i == words.length - 1;
      final displayValue = words[i].word;
      return TextSpan(text: isLast ? displayValue : '$displayValue, ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (translation.synonyms.isNotEmpty) ...[
        const SizedBox(height: 10),
        TranslationCardSection(
          name: 'Synonyms',
          icon: InputIcons.synonyms,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: OnlineTranslationFonts.sectionContentFontSize,
                  color: ContainerStyles.sectionTextColor(context)),
              children: <TextSpan>[
                ..._generateDutchTextSpans(translation),
              ],
            ),
          ),
        ),
      ],
    ]);
  }
}
