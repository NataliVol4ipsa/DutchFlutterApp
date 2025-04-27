import 'package:dutch_app/core/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/http_clients/vertalennu/vertalenu_client.dart';
import 'package:dutch_app/pages/word_editor/online_search/error_handling/word_search_exception_listener_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/error_handling/words_not_found_error_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_list_mapping_service.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translations_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_card_v2_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
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
  TranslationsSearchResult? onlineTranslationOptions;

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

    var grammarOptionsResponse = await WoordenlijstClient().findAsync(
      context,
      wordToLookup,
      wordType: widget.selectedWordType,
    );

    if (!mounted) return;

    final translationOptionsResponse =
        await VertalenNuClient().findDutchToEnglishAsync(context, wordToLookup);

    final mappedSearchResponse =
        OnlineTranslationListMappingService.mapToResult(
            translationOptionsResponse, grammarOptionsResponse);

    setState(() {
      grammarOptions = grammarOptionsResponse?.onlineWords;
      onlineTranslationOptions = mappedSearchResponse;
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
          if (onlineTranslationOptions == null ||
              onlineTranslationOptions!.translations.isEmpty) ...{
            WordsNotFoundError(),
          },
          if (onlineTranslationOptions != null &&
              onlineTranslationOptions!.translations.isNotEmpty) ...{
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onlineTranslationOptions!.translations.length,
              itemBuilder: (context, index) {
                final translation =
                    onlineTranslationOptions!.translations[index];
                return OnlineTranslationCardV2(translation: translation);
              },
            ),
          }
        ],
      ),
    );
  }
}
