import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_fonts.dart';
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
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: OnlineTranslationFonts.translationsFontSize,
                fontWeight: FontWeight.bold,
                color: ContainerStyles.sectionTextColor(context)),
            children: <TextSpan>[
              TextSpan(text: 'Synonyms:'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: OnlineTranslationFonts.synonymsFontSize,
                color: ContainerStyles.sectionTextColor(context)),
            children: <TextSpan>[
              ..._generateDutchTextSpans(translation),
            ],
          ),
        ),
      ],
    ]);
  }
}
