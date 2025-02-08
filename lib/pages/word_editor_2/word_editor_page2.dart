import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/http_clients/get_word_online_response.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';
import 'package:dutch_app/pages/word_editor_2/header_tab.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordEditorPage2 extends StatefulWidget {
  final int? existingWordId;
  const WordEditorPage2({super.key, this.existingWordId});

  @override
  State<WordEditorPage2> createState() => _WordEditorPage2State();
}

class _WordEditorPage2State extends State<WordEditorPage2> {
  Key key = UniqueKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNewWord = false;
  bool isLoading = false;

  Word? existingWord;

  late WordsRepository wordsRepository;

  late OnlineWordSearchSuggestionSelectedNotifier onlineWordSelectedNotifier;
  late void Function() onlineWordSelectedNotifierListener;

  List<HeaderTab> headerTabs = [
    HeaderTab(name: "All", widgetBuilder: (wordType) => Container()),
    HeaderTab(
        name: "Main",
        widgetBuilder: (wordType) => Container(),
        isSelected: true),
    HeaderTab(name: "Meta", widgetBuilder: (wordType) => Container()),
    HeaderTab(name: "Plurals", widgetBuilder: (wordType) => Container()),
    HeaderTab(name: "Past tense", widgetBuilder: (wordType) => Container()),
  ];

  @override
  void initState() {
    super.initState();
    _initIsNewWord();
    _initOnlineSearch();

    if (!isNewWord) {
      _initExistingWordAsync(widget.existingWordId!);
    }
  }

  void _initIsNewWord() {
    isNewWord = widget.existingWordId == null;
    if (!isNewWord) {
      isLoading = true;
    }
  }

  void _initOnlineSearch() {
    onlineWordSelectedNotifier =
        context.read<OnlineWordSearchSuggestionSelectedNotifier>();
    onlineWordSelectedNotifierListener = () {
      onlineWordSelectedNotifierAction(onlineWordSelectedNotifier.wordOption);
    };
    onlineWordSelectedNotifier.addListener(onlineWordSelectedNotifierListener);
  }

  // When online word is selected, apply its values to current word input fields
  void onlineWordSelectedNotifierAction(GetWordOnlineResponse? wordOption) {
    if (wordOption == null) {
      return;
    }
    setState(() {
      // selectedWordType = wordOption.partOfSpeech ?? WordType.none;
      // dutchPluralFormTextInputController.text = wordOption.pluralForm ?? "";
      // selectedDeHetType = wordOption.gender ?? DeHetType.none;
    });
  }

  @override
  void dispose() {
    super.dispose();
    onlineWordSelectedNotifier
        .removeListener(onlineWordSelectedNotifierListener);
  }

  Future<void> _initExistingWordAsync(int wordId) async {
    existingWord = await wordsRepository.getWordAsync(wordId);

    if (existingWord == null) {
      throw Exception("Failed to edit word with id '$wordId'");
    }

    // selectedWordType = existingWord.wordType;
    // selectedWordCollection = existingWord.collection;
    // dutchWordTextInputController.text = existingWord.dutchWord;
    // englishWordTextInputController.text = existingWord.englishWord;
    // dutchPluralFormTextInputController.text = existingWord.pluralForm ?? "";
    // selectedDeHetType = existingWord.deHetType;

    setState(() {
      isLoading = false;
    });
  }

  String getAppBarLabel() {
    if (isNewWord) return 'Add new word';
    return 'Edit word';
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      children: headerTabs.map((tab) => Text(tab.name)).toList(),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      isScrollable: true,
      tabs: headerTabs.map((headerTab) => Tab(text: headerTab.name)).toList(),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () => {},
                style: ButtonStyles.largeWidePrimaryButtonStyle(context),
                child: Text("Submit")),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: headerTabs.length,
      initialIndex: 1,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(getAppBarLabel()),
          disableSettingsButton: !isNewWord,
          bottom: _buildTabBar(context),
        ),
        body: _buildBody(context),
        bottomSheet: _buildSubmitButton(context),
      ),
    );
  }
}
