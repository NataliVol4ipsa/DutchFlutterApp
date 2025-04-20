import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_fonts.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordTranslations extends StatelessWidget {
  const OnlineTranslationWordTranslations({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  List<TextSpan> _generateEnglishTextSpans(
      DutchToEnglishTranslation translation) {
    final words = translation.englishWords;

    return List<TextSpan>.generate(words.length, (i) {
      return TextSpan(text: ' • ${words[i]}\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 8),
      // RichText(
      //   text: TextSpan(
      //     style: TextStyle(
      //         fontSize: OnlineTranslationFonts.translationsFontSize,
      //         fontWeight: FontWeight.bold,
      //         color: ContainerStyles.sectionTextColor(context)),
      //     children: <TextSpan>[
      //       TextSpan(text: 'Translation:'),
      //     ],
      //   ),
      // ),
      RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: OnlineTranslationFonts.translationsFontSize,
              color: ContainerStyles.sectionTextColor(context)),
          children: <TextSpan>[
            ..._generateEnglishTextSpans(translation),
          ],
        ),
      ),
    ]);
  }
}
