import 'package:dutch_app/core/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_word_attributes.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_word_examples.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_word_header.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_word_synonyms.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_word_translations.dart';
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
    return Card(
      color: ContainerStyles.sectionColor(context),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              color: ContainerStyles.secondaryHeaderColor(context),
              child: Padding(
                padding: ContainerStyles.containerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnlineTranslationWordHeader(translation: translation),
                    OnlineTranslationWordAttributes(translation: translation),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: ContainerStyles.containerPadding,
            child: Column(
              children: [
                OnlineTranslationWordTranslations(translation: translation),
                OnlineTranslationWordSynonyms(translation: translation),
                OnlineTranslationWordExamples(translation: translation),
              ],
            ),
          ),
          _generateApplyButton(context),
        ],
      ),
    );
  }

  Align _generateApplyButton(BuildContext context) {
    var translationSelectedNotifier =
        Provider.of<OnlineTranslationSearchSuggestionSelectedNotifier>(context,
            listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: ContainerStyles.defaultPaddingAmount,
            right: ContainerStyles.defaultPaddingAmount,
            left: ContainerStyles.defaultPaddingAmount),
        child: ElevatedButton.icon(
          onPressed: () {
            translationSelectedNotifier.notify(translation);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.check,
            size: 20,
          ),
          label: Text(
            'Apply',
            style: TextStyle(fontSize: ButtonStyles.mediumButtonFontSize),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48), // Makes full-width and tall
            backgroundColor: ContainerStyles.section3Color(context),
            foregroundColor: ContainerStyles.section3TextColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
