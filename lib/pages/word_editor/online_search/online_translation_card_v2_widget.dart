import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/gender_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_fonts.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_main_word.dart';
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
            OnlineTranslationMainWord(translation: translation),
            if (translation.synonyms.isNotEmpty) ...[
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: OnlineTranslationFonts.synonymsFontSize,
                      color: ContainerStyles.sectionTextColor(context)),
                  children: <TextSpan>[
                    ..._generateDutchTextSpans(translation),
                    //     TextSpan(
                    //       text: translation.word,
                    //       style: const TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            //     if (translation.note != null && translation.note != "")
            //       Text(
            //         'Note: ${translation.note}',
            //         style: TextStyle(
            //             color: ContainerStyles.sectionTextColor(context),
            //             fontSize: 16),
            //       ),

            //     if (translation.pluralForm != null)
            //       Text('Plural: ${translation.pluralForm}',
            //           style: const TextStyle(fontSize: 16)),
            //     if (translation.diminutive != null)
            //       Text('Diminutive: ${translation.diminutive}',
            //           style: const TextStyle(fontSize: 16)),
            //     Align(
            //       alignment: Alignment.bottomRight,
            //       child: TextButton(
            //         onPressed: () {
            //           wordSelectedNotifier.notify(translation);
            //           Navigator.pop(context);
            //         },
            //         style: ButtonStyles.mediumPrimaryButtonStyle(context),
            //         child: const Text('Apply'),
            //       ),
            //     ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: OnlineTranslationFonts.translationsFontSize,
                    color: ContainerStyles.sectionTextColor(context)),
                children: <TextSpan>[
                  // TextSpan(
                  //   text: 'English:\n',
                  //   style: TextStyle(fontStyle: FontStyle.italic),
                  // ),
                  ..._generateEnglishTextSpans(translation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _generateDutchTextSpans(
      DutchToEnglishTranslation translation) {
    final List<OnlineTranslationDutchWord> words = translation.synonyms;

    return List<TextSpan>.generate(words.length, (i) {
      final isLast = i == words.length - 1;
      final displayValue = words[i].word;
      return TextSpan(text: isLast ? displayValue : '$displayValue, ');
    });
  }

  List<TextSpan> _generateEnglishTextSpans(
      DutchToEnglishTranslation translation) {
    final words = translation.englishWords;

    return List<TextSpan>.generate(words.length, (i) {
      return TextSpan(text: ' • ${words[i]}\n');
    });
  }
}
