import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_fonts.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_word_attributes.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_word_header.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_word_synonyms.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_word_translations.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlineTranslationCardV2 extends StatelessWidget {
  const OnlineTranslationCardV2({
    super.key,
    required this.translation,
  });

  final DutchToEnglishTranslation translation;

  @override
  Widget build(BuildContext context) {
    var wordSelectedNotifier =
        Provider.of<OnlineWordSearchSuggestionSelectedNotifier>(context,
            listen: false);
    return Card(
      color: ContainerStyles.sectionColor(context),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: ContainerStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnlineTranslationWordHeader(translation: translation),
            OnlineTranslationWordAttributes(translation: translation),
            OnlineTranslationWordTranslations(translation: translation),
            OnlineTranslationWordSynonyms(translation: translation),
          ],
        ),
      ),
    );
  }
}
