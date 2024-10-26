import 'package:flutter/material.dart';
import 'package:first_project/core/http_clients/get_word_online_response.dart';
import 'package:first_project/core/http_clients/woordenlijst_client.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/core/types/de_het_type.dart';

class OnlineWordSearchSection extends StatefulWidget {
  final TextEditingController dutchWordTextInputController;
  final WordType? selectedWordType;
  final Function(GetWordOnlineResponse) onApplyOnlineWordPressed;
  final bool resetTrigger;

  const OnlineWordSearchSection({
    super.key,
    required this.dutchWordTextInputController,
    required this.selectedWordType,
    required this.onApplyOnlineWordPressed,
    required this.resetTrigger,
  });

  @override
  State<OnlineWordSearchSection> createState() =>
      _OnlineWordSearchSectionState();
}

class _OnlineWordSearchSectionState extends State<OnlineWordSearchSection> {
  bool searchComplete = false;
  List<GetWordOnlineResponse>? onlineWordOptions;

//todo move elsewhere
  String capitalizeEnum(Enum value) {
    final word = value.name;
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }

  Future<void> onSearchWordOnlineClicked() async {
    setState(() {
      searchComplete = false;
    });
    var response = await WoordenlijstClient().findAsync(
      widget.dutchWordTextInputController.text,
      wordType: widget.selectedWordType,
    );

    setState(() {
      onlineWordOptions = response.onlineWords;
      searchComplete = true;
    });
  }

  void resetSearchComplete() {
    setState(() {
      searchComplete = false;
      onlineWordOptions = null;
    });
  }

  @override
  void didUpdateWidget(covariant OnlineWordSearchSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetTrigger != oldWidget.resetTrigger && widget.resetTrigger) {
      resetSearchComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchComplete) ...{
          if (onlineWordOptions == null || onlineWordOptions!.isEmpty) ...{
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red[50],
                    child: const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "Failed to find word online",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          },
          if (onlineWordOptions != null && onlineWordOptions!.isNotEmpty) ...{
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onlineWordOptions?.length ?? 0,
              itemBuilder: (context, index) {
                final wordOption = onlineWordOptions![index];
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wordOption.word,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (wordOption.note != null && wordOption.note != "")
                          Text('Note: ${wordOption.note}'),
                        if (wordOption.partOfSpeech != null &&
                            wordOption.partOfSpeech != WordType.none)
                          Text(
                              'Part of Speech: ${capitalizeEnum(wordOption.partOfSpeech!)}'),
                        if (wordOption.gender != null &&
                            wordOption.gender != DeHetType.none)
                          Text('De/Het: ${capitalizeEnum(wordOption.gender!)}'),
                        if (wordOption.pluralForm != null)
                          Text('Plural: ${wordOption.pluralForm}'),
                        if (wordOption.diminutive != null)
                          Text('Diminutive: ${wordOption.diminutive}'),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onApplyOnlineWordPressed(wordOption);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          }
        },
        ValueListenableBuilder(
          valueListenable: widget.dutchWordTextInputController,
          builder: (context, TextEditingValue value, child) {
            return ElevatedButton(
              onPressed:
                  value.text.trim() == "" ? null : onSearchWordOnlineClicked,
              child: const Text("Search word online"),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
