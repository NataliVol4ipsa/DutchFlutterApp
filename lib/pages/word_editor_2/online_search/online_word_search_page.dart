import 'package:dutch_app/pages/word_editor_2/online_search/error_handling/word_search_exception_listener_widget.dart';
import 'package:dutch_app/pages/word_editor_2/online_search/error_handling/words_not_found_error_widget.dart';
import 'package:dutch_app/pages/word_editor_2/online_search/online_word_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/http_clients/get_word_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst_client.dart';
import 'package:dutch_app/core/types/word_type.dart';

class OnlineWordSearchPage extends StatefulWidget {
  final String word;
  final WordType? selectedWordType;

  const OnlineWordSearchPage({
    super.key,
    required this.word,
    this.selectedWordType,
  });

  @override
  State<OnlineWordSearchPage> createState() => _OnlineWordSearchPageState();
}

class _OnlineWordSearchPageState extends State<OnlineWordSearchPage> {
  bool isLoading = false;
  List<GetWordOnlineResponse>? onlineWordOptions;

  @override
  void initState() {
    super.initState();

    _loadDataAsync();
  }

  Future<void> _loadDataAsync() async {
    setState(() {
      isLoading = true;
    });
    var response = await WoordenlijstClient().findAsync(
      context,
      widget.word,
      wordType: widget.selectedWordType,
    );

    setState(() {
      onlineWordOptions = response?.onlineWords;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        WordSearchExceptionListener(),
        if (onlineWordOptions == null || onlineWordOptions!.isEmpty) ...{
          WordsNotFoundError(),
        },
        if (onlineWordOptions != null && onlineWordOptions!.isNotEmpty) ...{
          ListView.builder(
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: onlineWordOptions?.length ?? 0,
            itemBuilder: (context, index) {
              final word = onlineWordOptions![index];
              return OnlineWordCard(wordResponse: word);
            },
          ),
        }
      ],
    );
  }
}
