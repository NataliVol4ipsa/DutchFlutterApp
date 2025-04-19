import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_translation.dart';
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
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     RichText(
        //       text: TextSpan(
        //         style: TextStyle(
        //             fontSize: 20,
        //             color: ContainerStyles.sectionTextColor(context)),
        //         children: <TextSpan>[
        //           if (translation.gender != null &&
        //               translation.gender != DeHetType.none) ...[
        //             TextSpan(text: translation.gender!.label),
        //             const TextSpan(text: ' '),
        //           ],
        //           TextSpan(
        //             text: translation.word,
        //             style: const TextStyle(fontWeight: FontWeight.bold),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(height: 8),
        //     if (translation.note != null && translation.note != "")
        //       Text(
        //         'Note: ${translation.note}',
        //         style: TextStyle(
        //             color: ContainerStyles.sectionTextColor(context),
        //             fontSize: 16),
        //       ),
        //     if (translation.partOfSpeech != null &&
        //         translation.partOfSpeech != WordType.unspecified)
        //       Text(
        //           'Part of Speech: ${capitalizeEnum(translation.partOfSpeech!)}',
        //           style: const TextStyle(fontSize: 16)),
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
        //   ],
        // ),
      ),
    );
  }
}
