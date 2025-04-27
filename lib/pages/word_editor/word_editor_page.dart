import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/core/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:dutch_app/core/services/collection_permission_service.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/online_translation_list_mapping_service.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/tabs/meta_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/past_tense_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/plurals_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/main_tab_widget.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordEditorPage extends StatefulWidget {
  const WordEditorPage({super.key});

  @override
  State<WordEditorPage> createState() => _WordEditorPageState();
}

class _WordEditorPageState extends State<WordEditorPage>
    with TickerProviderStateMixin {
  Key key = UniqueKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int? existingWordId;

  bool _isNewWord = false;
  bool _isLoading = false;

  late WordsRepository _wordsRepository;

  late OnlineTranslationSearchSuggestionSelectedNotifier
      _onlineTranslationSelectedNotifier;
  late void Function() _onlineTranslationSelectedNotifierListener;

  final TextEditingController _dutchWordController = TextEditingController();
  final TextEditingController _englishWordController = TextEditingController();
  final TextEditingController _dutchPluralFormController =
      TextEditingController();
  final ValueNotifier<WordType> _wordTypeController =
      ValueNotifier<WordType>(WordType.unspecified);
  final ValueNotifier<WordCollection> _wordCollectionController =
      ValueNotifier<WordCollection>(WordCollection(
          CollectionPermissionService.defaultCollectionId,
          CollectionPermissionService.defaultCollectionName));
  final ValueNotifier<DeHetType> _deHetTypeTypeController =
      ValueNotifier<DeHetType>(DeHetType.none);
  final TextEditingController _contextExampleController =
      TextEditingController();
  final TextEditingController _contextExampleTranslationController =
      TextEditingController();
  final TextEditingController _userNoteController = TextEditingController();

  late TabController _tabController;
  final ValueNotifier<List<Tab>> _tabsNotifier = ValueNotifier<List<Tab>>([]);
  final ValueNotifier<List<Widget>> _tabViewsNotifier =
      ValueNotifier<List<Widget>>([]);

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _wordsRepository = context.read<WordsRepository>();
    _tabController = TabController(length: 0, vsync: this);
    _initOnlineSearch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) return;

    existingWordId = ModalRoute.of(context)!.settings.arguments as int?;
    _initIsNewWord();
    if (!_isNewWord) {
      _initExistingWordAsync(existingWordId!);
    }
    _initTabs();
    initialized = true;
  }

  void _initIsNewWord() {
    _isNewWord = existingWordId == null;
    if (!_isNewWord) {
      _isLoading = true;
    }
  }

  void _initOnlineSearch() {
    _onlineTranslationSelectedNotifier =
        context.read<OnlineTranslationSearchSuggestionSelectedNotifier>();
    _onlineTranslationSelectedNotifierListener = () {
      onlineTranslationSelectedNotifierAction(
          _onlineTranslationSelectedNotifier.translation,
          _onlineTranslationSelectedNotifier.grammarOptions);
    };
    _onlineTranslationSelectedNotifier
        .addListener(_onlineTranslationSelectedNotifierListener);
  }

  void _initTabs() {
    _updateTabs();

    _wordTypeController.addListener(() {
      _updateTabs();
    });
  }

  void _updateTabs() {
    final List<Tab> newTabs = [
      const Tab(text: "All"),
      const Tab(text: "Main"),
      if (PluralsTab.shouldShowTab(_wordTypeController.value))
        const Tab(text: "Plurals"),
      if (PastTenseTab.shouldShowTab(_wordTypeController.value))
        const Tab(text: "Past tense"),
      if (MetaTab.shouldShowTab(_wordTypeController.value))
        const Tab(text: "Meta"),
    ];

    final List<Widget> newTabViews = [
      _tab(_buildAllTab()),
      _tab(_buildMainTab()),
      if (PluralsTab.shouldShowTab(_wordTypeController.value))
        _tab(_buildPluralsTab()),
      if (PastTenseTab.shouldShowTab(_wordTypeController.value))
        _tab(_buildPastTenseTab()),
      if (MetaTab.shouldShowTab(_wordTypeController.value))
        _tab(_buildMetaTab()),
    ];

    _tabsNotifier.value = newTabs;
    _tabViewsNotifier.value = newTabViews;

    int activeIndex = _tabController.index;
    _tabController.dispose();
    _tabController = TabController(
        length: newTabs.length,
        vsync: this,
        initialIndex: initialized
            ? activeIndex
            : _isNewWord
                ? 1
                : 0);
    setState(() {});
  }

  // When online translation is selected, apply its values to current word input fields
  void onlineTranslationSelectedNotifierAction(
      TranslationSearchResult? translation,
      List<GetWordGrammarOnlineResponse>? grammarOptions) {
    if (translation == null) {
      return;
    }

    String? pluralForm = OnlineTranslationListMappingService.findNounPluralForm(
        translation.partOfSpeech ?? WordType.phrase, grammarOptions);

    final englishTranslations = translation.translationWords
        .where((w) => w.isSelected)
        .map((w) => w.value)
        .join(";");
    final contextExampleTranslation = translation
        .sentenceExamples.firstOrNull?.englishSentence
        .replaceAll(RegExp(r'<[^>]*>'), '');
    final contextExample = translation
        .sentenceExamples.firstOrNull?.dutchSentence
        .replaceAll(RegExp(r'<[^>]*>'), '');

    setState(() {
      _dutchWordController.text = translation.mainWord;
      _wordTypeController.value = translation.partOfSpeech ?? WordType.phrase;
      _englishWordController.text = englishTranslations;
      _deHetTypeTypeController.value = translation.article ?? DeHetType.none;
      _contextExampleController.text = contextExample ?? "";
      _contextExampleTranslationController.text =
          contextExampleTranslation ?? "";
      _dutchPluralFormController.text = pluralForm ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onlineTranslationSelectedNotifier
        .removeListener(_onlineTranslationSelectedNotifierListener);
    _tabController.dispose();
    _wordTypeController.dispose();
    _tabsNotifier.dispose();
    _tabViewsNotifier.dispose();
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
    _wordCollectionController.value =
        existingWord.collection ?? _wordCollectionController.value;
    _deHetTypeTypeController.value = existingWord.deHetType;
    _contextExampleController.text = existingWord.contextExample ?? "";
    _contextExampleTranslationController.text =
        existingWord.contextExampleTranslation ?? "";
    _userNoteController.text = existingWord.userNote ?? "";

    setState(() {
      _isLoading = false;
    });
  }

  String getAppBarLabel() {
    if (_isNewWord) return 'Add new word';
    return 'Edit word';
  }

  Widget _tab(Widget child) {
    return Padding(
        padding: ContainerStyles.containerPadding,
        child: SingleChildScrollView(child: child));
  }

  Widget _buildAllTab() {
    return Column(
      children: [
        _buildMainTab(),
        if (PluralsTab.shouldShowTab(_wordTypeController.value))
          _buildPluralsTab(),
        if (PastTenseTab.shouldShowTab(_wordTypeController.value))
          _buildPastTenseTab(),
        if (MetaTab.shouldShowTab(_wordTypeController.value)) _buildMetaTab(),
      ],
    );
  }

  Widget _buildMainTab() {
    return MainTab(
      wordTypeGetter: () => _wordTypeController.value,
      dutchWordController: _dutchWordController,
      englishWordController: _englishWordController,
      wordTypeValueNotifier: _wordTypeController,
      collectionValueNotifier: _wordCollectionController,
      deHetValueNotifier: _deHetTypeTypeController,
    );
  }

  Widget _buildPluralsTab() {
    return PluralsTab(
      wordTypeGetter: () => _wordTypeController.value,
      dutchPluralFormController: _dutchPluralFormController,
    );
  }

  Widget _buildMetaTab() {
    return MetaTab(
      contextExampleController: _contextExampleController,
      contextExampleTranslationController: _contextExampleTranslationController,
      userNoteController: _userNoteController,
    );
  }

  Widget _buildPastTenseTab() {
    return Text("Past Tense");
  }

  PreferredSize _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: ValueListenableBuilder<List<Tab>>(
        valueListenable: _tabsNotifier,
        builder: (context, tabs, _) {
          return TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            isScrollable: true,
            controller: _tabController,
            tabs: tabs,
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ValueListenableBuilder<List<Widget>>(
      valueListenable: _tabViewsNotifier,
      builder: (context, tabViews, _) {
        return TabBarView(
          controller: _tabController,
          children: tabViews,
        );
      },
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
      dutchWordInput.trim(),
      englishWordInput.trim(),
      _wordTypeController.value,
      collection: _wordCollectionController.value,
      deHetType: _deHetTypeTypeController.value,
      pluralForm: dutchPluralFormWordInput.trim(),
      contextExample: _contextExampleController.text.trim(),
      contextExampleTranslation:
          _contextExampleTranslationController.text.trim(),
      userNote: _userNoteController.text.trim(),
    );

    await _wordsRepository.addAsync(newWord);
  }

  Future<void> updateWordAsync() async {
    if (_isNewWord) return;

    String dutchWordInput = _dutchWordController.text;
    String englishWordInput = _englishWordController.text;
    String dutchPluralFormWordInput = _dutchPluralFormController.text;

    var updatedWord = Word(
      existingWordId!,
      dutchWordInput.trim(),
      englishWordInput.trim(),
      _wordTypeController.value,
      collection: _wordCollectionController.value,
      deHetType: _deHetTypeTypeController.value,
      pluralForm: dutchPluralFormWordInput.trim(),
      contextExample: _contextExampleController.text.trim(),
      contextExampleTranslation:
          _contextExampleTranslationController.text.trim(),
      userNote: _userNoteController.text.trim(),
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
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(getAppBarLabel()),
          disableSettingsButton: !_isNewWord,
          bottom: _buildTabBar(context),
        ),
        body: _buildBody(context),
        bottomNavigationBar: _buildSubmitButton(context),
      ),
    );
  }
}
