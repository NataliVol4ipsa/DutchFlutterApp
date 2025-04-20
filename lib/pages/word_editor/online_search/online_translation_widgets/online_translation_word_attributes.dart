import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordAttributes extends StatelessWidget {
  const OnlineTranslationWordAttributes({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  @override
  Widget build(BuildContext context) {
    bool showPartOfSpeech = translation.partOfSpeech.isNotEmpty &&
        translation.partOfSpeech.first != WordType.unspecified;
    bool showGender = translation.mainWord.gender != null &&
        translation.mainWord.gender != GenderType.none;
    return Column(
      children: [
        if (showPartOfSpeech || showGender) const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: OnlineTranslationFonts.mainWordFontSize,
                color: BaseStyles.getColorScheme(context).secondary),
            children: <TextSpan>[
              if (showPartOfSpeech)
                TextSpan(
                  text: translation.partOfSpeech.first.capitalLabel,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: OnlineTranslationFonts.attributeFontSize,
                    color: ContainerStyles.sectionTextColor(context)
                        .withAlpha(150),
                  ),
                ),
              if (showGender)
                TextSpan(
                  text: ", [${translation.mainWord.gender!.emptyOnNone}]",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: OnlineTranslationFonts.attributeFontSize,
                    color: ContainerStyles.sectionTextColor(context)
                        .withAlpha(150),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
