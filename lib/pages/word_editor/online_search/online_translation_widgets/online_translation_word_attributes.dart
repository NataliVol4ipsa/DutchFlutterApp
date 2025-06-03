import 'package:dutch_app/domain/types/gender_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordAttributes extends StatelessWidget {
  const OnlineTranslationWordAttributes({
    super.key,
    required this.translation,
  });

  final TranslationSearchResult translation;
  final int _alpha = 175; //0..255

  @override
  Widget build(BuildContext context) {
    bool showPartOfSpeech =
        translation.partOfSpeech != PartOfSpeech.unspecified;
    bool showGender =
        translation.gender != null && translation.gender != GenderType.none;
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
                  text: translation.partOfSpeech?.capitalLabel,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: OnlineTranslationFonts.attributeFontSize,
                    color: ContainerStyles.sectionTextColor(context)
                        .withAlpha(_alpha),
                  ),
                ),
              if (showGender)
                TextSpan(
                  text: ", [${translation.gender!.emptyOnNone}]",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: OnlineTranslationFonts.attributeFontSize,
                    color: ContainerStyles.sectionTextColor(context)
                        .withAlpha(_alpha),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
