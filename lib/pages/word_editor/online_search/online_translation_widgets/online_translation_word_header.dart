import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordHeader extends StatelessWidget {
  const OnlineTranslationWordHeader({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: OnlineTranslationFonts.mainWordFontSize,
          color: ContainerStyles.selectedSecondaryTextColor(context),
        ),
        children: <TextSpan>[
          if (translation.mainWord.article != null &&
              translation.mainWord.article != DeHetType.none) ...[
            TextSpan(
              text: translation.mainWord.article!.label,
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: translation.mainWord.word,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
