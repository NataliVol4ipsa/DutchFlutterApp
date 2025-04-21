import 'package:dutch_app/core/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/http_clients/vertalennu/models/dutch_to_english_search_result.dart';
import 'package:dutch_app/http_clients/vertalennu/vertalenu_client.dart';
import 'package:dutch_app/pages/word_editor/online_search/error_handling/word_search_exception_listener_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/error_handling/words_not_found_error_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_card_v2_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/http_clients/woordenlijst/get_word_grammar_online_response.dart';
import 'package:dutch_app/http_clients/woordenlijst/woordenlijst_client.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:provider/provider.dart';

class OnlineWordSearchPage extends StatefulWidget {
  final String word;
  final WordType? selectedWordType;

  OnlineWordSearchPage({
    super.key,
    required String word,
    this.selectedWordType,
  }) : word = word.trim();

  @override
  State<OnlineWordSearchPage> createState() => _OnlineWordSearchPageState();
}

class _OnlineWordSearchPageState extends State<OnlineWordSearchPage> {
  bool isLoading = false;
  List<GetWordGrammarOnlineResponse>? grammarOptions;
  DutchToEnglishSearchResult? onlineWordOptions2;

  late OnlineTranslationSearchSuggestionSelectedNotifier
      _onlineTranslationSelectedNotifier;

  @override
  void initState() {
    super.initState();

    _onlineTranslationSelectedNotifier =
        context.read<OnlineTranslationSearchSuggestionSelectedNotifier>();

    _loadDataAsync();
  }

  Future<void> _loadDataAsync() async {
    setState(() {
      isLoading = true;
    });
    final wordToLookup = widget.word.trim();
    var response = await WoordenlijstClient().findAsync(
      context,
      wordToLookup,
      wordType: widget.selectedWordType,
    );

    if (!mounted) return;

    var responseV2 =
        await VertalenNuClient().findDutchToEnglishAsync(context, wordToLookup);

    responseV2?.translations
        .sort((a, b) => b.translationScore.compareTo(a.translationScore));

    setState(() {
      grammarOptions = response?.onlineWords;
      onlineWordOptions2 = responseV2;
      isLoading = false;
    });
    _onlineTranslationSelectedNotifier.setGrammarOptions(grammarOptions);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          WordSearchExceptionListener(),
          if (onlineWordOptions2 == null ||
              onlineWordOptions2!.translations.isEmpty) ...{
            WordsNotFoundError(),
          },
          if (grammarOptions != null &&
              onlineWordOptions2!.translations.isNotEmpty) ...{
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onlineWordOptions2!.translations.length,
              itemBuilder: (context, index) {
                final translation = onlineWordOptions2!.translations[index];
                return OnlineTranslationCardV2(translation: translation);
              },
            ),
          }
        ],
      ),
    );
  }
}
