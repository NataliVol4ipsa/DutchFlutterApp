import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordHeader extends StatelessWidget {
  const OnlineTranslationWordHeader({
    super.key,
    required this.translation,
  });

  final TranslationSearchResult translation;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: OnlineTranslationFonts.mainWordFontSize,
          color: ContainerStyles.secondaryHeaderTextColor(context),
        ),
        children: <TextSpan>[
          if (translation.nounDetails?.article != null &&
              translation.nounDetails!.article != DeHetType.none) ...[
            TextSpan(
              text: translation.nounDetails!.article!.label,
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: translation.mainWord,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
