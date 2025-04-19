import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_fonts.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationMainWord extends StatelessWidget {
  const OnlineTranslationMainWord({
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
            color: BaseStyles.getColorScheme(context).secondary),
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
          if (translation.partOfSpeech.isNotEmpty &&
              translation.partOfSpeech.first != WordType.unspecified)
            TextSpan(
              text: " [${translation.partOfSpeech.first.capitalLabel}]",
              style: TextStyle(
                fontSize: OnlineTranslationFonts.mainWordFontSize - 2,
                color: ContainerStyles.sectionTextColor(context).withAlpha(150),
              ),
            ),
          if (translation.mainWord.gender != null &&
              translation.mainWord.gender != GenderType.none)
            TextSpan(
              text: " (${translation.mainWord.gender!.emptyOnNone})",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: OnlineTranslationFonts.mainWordFontSize - 2,
                color: ContainerStyles.sectionTextColor(context).withAlpha(150),
              ),
            ),
        ],
      ),
    );
  }
}
