import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:dutch_app/core/services/collection_permission_service.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/get_word_online_response.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';
import 'package:dutch_app/pages/word_editor_2/tabs/main_tab_widget.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
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

  WordType selectedWordType = WordType.none;

  late WordsRepository wordsRepository;

  late OnlineWordSearchSuggestionSelectedNotifier onlineWordSelectedNotifier;
  late void Function() onlineWordSelectedNotifierListener;

  TextEditingController dutchWordController = TextEditingController();
  TextEditingController englishWordController = TextEditingController();
  TextEditingController dutchPluralFormController = TextEditingController();
  ValueNotifier<WordType> wordTypeController =
      ValueNotifier<WordType>(WordType.none);
  ValueNotifier<WordCollection> wordCollectionController =
      ValueNotifier<WordCollection>(WordCollection(
          CollectionPermissionService.defaultCollectionId,
          CollectionPermissionService.defaultCollectionName));

  //todo filter based on word type
  List<String> headerTabs = [
    "All",
    "Main",
    "Meta",
    "Plurals",
    "Past tense",
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
      wordTypeController.value = wordOption.partOfSpeech ?? WordType.none;
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
    var existingWord = await wordsRepository.getWordAsync(wordId);

    if (existingWord == null) {
      throw Exception("Failed to edit word with id '$wordId'");
    }

    dutchWordController.text = existingWord.dutchWord;
    englishWordController.text = existingWord.englishWord;
    wordTypeController.value = existingWord.wordType;
    // selectedWordCollection = existingWord.collection;
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
    return TabBarView(children: [
      Padding(padding: ContainerStyles.containerPadding, child: _buildAllTab()),
      Padding(
          padding: ContainerStyles.containerPadding, child: _buildMainTab()),
      Padding(
          padding: ContainerStyles.containerPadding, child: _buildMetaTab()),
      Padding(
          padding: ContainerStyles.containerPadding, child: _buildPluralsTab()),
      Padding(
          padding: ContainerStyles.containerPadding,
          child: _buildPastTenseTab()),
    ]);
  }

  Widget _buildAllTab() {
    return Column(
      children: [
        _buildMainTab(),
        _buildMetaTab(),
        _buildPluralsTab(),
        _buildPastTenseTab(),
      ],
    );
  }

  Widget _buildMainTab() {
    return MainTab(
      dutchWordController: dutchWordController,
      englishWordController: englishWordController,
      wordTypeValueNotifier: wordTypeController,
      collectionValueNotifier: wordCollectionController,
    );
  }

  Widget _buildMetaTab() {
    return Text("Meta");
  }

  Widget _buildPluralsTab() {
    return Text("Plurals");
  }

  Widget _buildPastTenseTab() {
    return Text("Past Tense");
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      isScrollable: true,
      tabs: headerTabs.map((headerTab) => Tab(text: headerTab)).toList(),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: ContainerStyles.containerPadding,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _submitChangesAsync();
                  }
                },
                style: ButtonStyles.mediumPrimaryButtonStyle(context,
                    fontWeight: FontWeight.bold),
                child: Text(getSubmitButtonLabel())),
          ),
        ],
      ),
    );
  }

  String getSubmitButtonLabel() {
    if (isNewWord) return 'Add word';
    return 'Save changes';
  }

  Future<void> _submitChangesAsync() async {
    if (!_formKey.currentState!.validate()) return;
    var wordCreatedNotifier =
        Provider.of<WordCreatedNotifier>(context, listen: false);
    if (isNewWord) {
      notifyWordCreated(context);
      await createWordAsync();
      wordCreatedNotifier.notify();
    } else {
      await updateWordAsync();
      wordCreatedNotifier.notify();
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> createWordAsync() async {
    String dutchWordInput = dutchWordController.text;
    String englishWordInput = englishWordController.text;
    //String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var newWord = NewWord(
      dutchWordInput, englishWordInput, selectedWordType,
      // deHetType: selectedDeHetType!,
      // pluralForm: dutchPluralFormWordInput,
      collection: wordCollectionController.value,
    );

    await wordsRepository.addAsync(newWord);
  }

  Future<void> updateWordAsync() async {
    if (isNewWord) return;

    String dutchWordInput = dutchWordController.text;
    String englishWordInput = englishWordController.text;
    //String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var updatedWord = Word(
      widget.existingWordId!, dutchWordInput,
      englishWordInput, selectedWordType,
      // deHetType: selectedDeHetType!,
      // pluralForm: dutchPluralFormWordInput,
      collection: wordCollectionController.value,
    );

    await wordsRepository.updateAsync(updatedWord);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: DefaultTabController(
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
      ),
    );
  }
}
