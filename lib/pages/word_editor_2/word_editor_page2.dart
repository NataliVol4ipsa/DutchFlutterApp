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
import 'package:dutch_app/pages/word_editor_2/tabs/extra_tab_widget.dart';
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

  bool _isNewWord = false;
  bool _isLoading = false;

  late WordsRepository _wordsRepository;

  late OnlineWordSearchSuggestionSelectedNotifier _onlineWordSelectedNotifier;
  late void Function() _onlineWordSelectedNotifierListener;

  final TextEditingController _dutchWordController = TextEditingController();
  final TextEditingController _englishWordController = TextEditingController();
  final TextEditingController _dutchPluralFormController =
      TextEditingController();
  final ValueNotifier<WordType> _wordTypeController =
      ValueNotifier<WordType>(WordType.none);
  final ValueNotifier<WordCollection> _wordCollectionController =
      ValueNotifier<WordCollection>(WordCollection(
          CollectionPermissionService.defaultCollectionId,
          CollectionPermissionService.defaultCollectionName));

  final List<String> _headerTabs = [
    "All",
    "Main",
    "Extra",
    "Meta",
    "Plurals",
    "Past tense",
  ];

  @override
  void initState() {
    super.initState();
    _initIsNewWord();
    _initOnlineSearch();

    if (!_isNewWord) {
      _initExistingWordAsync(widget.existingWordId!);
    }
  }

  void _initIsNewWord() {
    _isNewWord = widget.existingWordId == null;
    if (!_isNewWord) {
      _isLoading = true;
    }
  }

  void _initOnlineSearch() {
    _onlineWordSelectedNotifier =
        context.read<OnlineWordSearchSuggestionSelectedNotifier>();
    _onlineWordSelectedNotifierListener = () {
      onlineWordSelectedNotifierAction(_onlineWordSelectedNotifier.wordOption);
    };
    _onlineWordSelectedNotifier
        .addListener(_onlineWordSelectedNotifierListener);
  }

  // When online word is selected, apply its values to current word input fields
  void onlineWordSelectedNotifierAction(GetWordOnlineResponse? wordOption) {
    if (wordOption == null) {
      return;
    }
    setState(() {
      _wordTypeController.value = wordOption.partOfSpeech ?? WordType.none;
      _dutchPluralFormController.text = wordOption.pluralForm ?? "";
      // selectedDeHetType = wordOption.gender ?? DeHetType.none;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onlineWordSelectedNotifier
        .removeListener(_onlineWordSelectedNotifierListener);
  }

  Future<void> _initExistingWordAsync(int wordId) async {
    var existingWord = await _wordsRepository.getWordAsync(wordId);

    if (existingWord == null) {
      throw Exception("Failed to edit word with id '$wordId'");
    }

    _dutchWordController.text = existingWord.dutchWord;
    _englishWordController.text = existingWord.englishWord;
    _wordTypeController.value = existingWord.wordType;
    _dutchPluralFormController.text = existingWord.pluralForm ?? "";
    // selectedWordCollection = existingWord.collection;
    // selectedDeHetType = existingWord.deHetType;

    setState(() {
      _isLoading = false;
    });
  }

  String getAppBarLabel() {
    if (_isNewWord) return 'Add new word';
    return 'Edit word';
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(children: [
      Padding(padding: ContainerStyles.containerPadding, child: _buildAllTab()),
      Padding(
          padding: ContainerStyles.containerPadding, child: _buildMainTab()),
      Padding(
          padding: ContainerStyles.containerPadding, child: _buildExtraTab()),
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
        if (ExtraTab.shouldShowTab(_wordTypeController.value)) _buildExtraTab(),
        _buildMetaTab(),
        _buildPluralsTab(),
        _buildPastTenseTab(),
      ],
    );
  }

  Widget _buildMainTab() {
    return MainTab(
      dutchWordController: _dutchWordController,
      englishWordController: _englishWordController,
      wordTypeValueNotifier: _wordTypeController,
      collectionValueNotifier: _wordCollectionController,
    );
  }

  Widget _buildExtraTab() {
    return ExtraTab(
      wordTypeGetter: () => _wordTypeController.value,
      dutchPluralFormController: _dutchPluralFormController,
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
      tabs: _headerTabs.map((headerTab) => Tab(text: headerTab)).toList(),
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
    if (_isNewWord) return 'Add word';
    return 'Save changes';
  }

  Future<void> _submitChangesAsync() async {
    if (!_formKey.currentState!.validate()) return;
    var wordCreatedNotifier =
        Provider.of<WordCreatedNotifier>(context, listen: false);
    if (_isNewWord) {
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
    String dutchWordInput = _dutchWordController.text;
    String englishWordInput = _englishWordController.text;
    String dutchPluralFormWordInput = _dutchPluralFormController.text;

    var newWord = NewWord(
      dutchWordInput, englishWordInput, _wordTypeController.value,
      // deHetType: selectedDeHetType!,
      pluralForm: dutchPluralFormWordInput,
      collection: _wordCollectionController.value,
    );

    await _wordsRepository.addAsync(newWord);
  }

  Future<void> updateWordAsync() async {
    if (_isNewWord) return;

    String dutchWordInput = _dutchWordController.text;
    String englishWordInput = _englishWordController.text;
    String dutchPluralFormWordInput = _dutchPluralFormController.text;

    var updatedWord = Word(
      widget.existingWordId!, dutchWordInput,
      englishWordInput, _wordTypeController.value,
      // deHetType: selectedDeHetType!,
      pluralForm: dutchPluralFormWordInput,
      collection: _wordCollectionController.value,
    );

    await _wordsRepository.updateAsync(updatedWord);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: _headerTabs.length,
        initialIndex: 1,
        child: Scaffold(
          appBar: MyAppBar(
            title: Text(getAppBarLabel()),
            disableSettingsButton: !_isNewWord,
            bottom: _buildTabBar(context),
          ),
          body: _buildBody(context),
          bottomSheet: _buildSubmitButton(context),
        ),
      ),
    );
  }
}
