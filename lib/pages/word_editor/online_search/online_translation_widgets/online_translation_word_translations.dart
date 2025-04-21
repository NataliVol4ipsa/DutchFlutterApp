import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/translation_card_section_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordTranslations extends StatelessWidget {
  const OnlineTranslationWordTranslations({
    super.key,
    required this.translation,
  });

  final TranslationSearchResult translation;

  List<TextSpan> _generateEnglishTextSpans(
      TranslationSearchResult translation) {
    final words = translation.translationWords;

    return List<TextSpan>.generate(words.length, (i) {
      var result = '•  ${words[i]}'; // •
      if (i < words.length - 1) result += '\n';
      return TextSpan(text: result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 8),
      TranslationCardSection(
        name: 'Translation',
        icon: InputIcons.englishWord,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: OnlineTranslationFonts.sectionContentFontSize,
                color: ContainerStyles.sectionTextColor(context)),
            children: <TextSpan>[
              ..._generateEnglishTextSpans(translation),
            ],
          ),
        ),
      ),
    ]);
  }
}
