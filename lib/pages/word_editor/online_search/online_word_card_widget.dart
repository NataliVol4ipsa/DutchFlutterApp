import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/get_word_online_response.dart';
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: ContainerStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wordResponse.word,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (wordResponse.note != null && wordResponse.note != "")
              Text('Note: ${wordResponse.note}'),
            if (wordResponse.partOfSpeech != null &&
                wordResponse.partOfSpeech != WordType.none)
              Text(
                  'Part of Speech: ${capitalizeEnum(wordResponse.partOfSpeech!)}'),
            if (wordResponse.gender != null &&
                wordResponse.gender != DeHetType.none)
              Text('De/Het: ${capitalizeEnum(wordResponse.gender!)}'),
            if (wordResponse.pluralForm != null)
              Text('Plural: ${wordResponse.pluralForm}'),
            if (wordResponse.diminutive != null)
              Text('Diminutive: ${wordResponse.diminutive}'),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  wordSelectedNotifier.notify(wordResponse);
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
