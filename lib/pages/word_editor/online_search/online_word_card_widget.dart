import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_online_response.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlineWordCard extends StatelessWidget {
  const OnlineWordCard({
    super.key,
    required this.wordResponse,
  });

  final GetWordOnlineResponse wordResponse;

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
            RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 20,
                    color: ContainerStyles.sectionTextColor(context)),
                children: <TextSpan>[
                  if (wordResponse.gender != null &&
                      wordResponse.gender != DeHetType.none) ...[
                    TextSpan(text: wordResponse.gender!.label),
                    const TextSpan(text: ' '),
                  ],
                  TextSpan(
                    text: wordResponse.word,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (wordResponse.note != null && wordResponse.note != "")
              Text(
                'Note: ${wordResponse.note}',
                style: TextStyle(
                    color: ContainerStyles.sectionTextColor(context),
                    fontSize: 16),
              ),
            if (wordResponse.partOfSpeech != null &&
                wordResponse.partOfSpeech != WordType.unspecified)
              Text(
                  'Part of Speech: ${capitalizeEnum(wordResponse.partOfSpeech!)}',
                  style: const TextStyle(fontSize: 16)),
            if (wordResponse.pluralForm != null)
              Text('Plural: ${wordResponse.pluralForm}',
                  style: const TextStyle(fontSize: 16)),
            if (wordResponse.diminutive != null)
              Text('Diminutive: ${wordResponse.diminutive}',
                  style: const TextStyle(fontSize: 16)),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  wordSelectedNotifier.notify(wordResponse);
                  Navigator.pop(context);
                },
                style: ButtonStyles.mediumPrimaryButtonStyle(context),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
