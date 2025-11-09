import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/domain/notifiers/online_translation_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/domain/notifiers/word_created_notifier.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/http_clients/woordenlijst/models/get_word_grammar_online_response.dart';
import 'package:dutch_app/pages/word_editor/controllers/main_controllers.dart';
import 'package:dutch_app/pages/word_editor/controllers/noun_controllers.dart';
import 'package:dutch_app/pages/word_editor/controllers/verb_controllers.dart';
import 'package:dutch_app/pages/word_editor/online_search/mapping/controllers_to_words_mapping_service.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/tabs/meta_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/noun_forms_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/main_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/verb_forms_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/verb_imperative_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/verb_past_tense_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/verb_present_participle_tab_widget.dart';
import 'package:dutch_app/pages/word_editor/tabs/verb_present_tense_tab_widget.dart';
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

  final MainControllers _mainControllers = MainControllers();
  final NounControllers _nounControllers = NounControllers();
  final VerbControllers _verbControllers = VerbControllers();

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

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is int?) {
      existingWordId = args;
    } else if (args is Map && args['prefillDutch'] != null) {
      existingWordId = null;
      _mainControllers.dutchWordController.text = args['prefillDutch'] ?? '';
    } else {
      existingWordId = null;
    }
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
    _onlineTranslationSelectedNotifier = context
        .read<OnlineTranslationSearchSuggestionSelectedNotifier>();
    _onlineTranslationSelectedNotifierListener = () {
      onlineTranslationSelectedNotifierAction(
        _onlineTranslationSelectedNotifier.translation,
        _onlineTranslationSelectedNotifier.grammarOptions,
      );
    };
    _onlineTranslationSelectedNotifier.addListener(
      _onlineTranslationSelectedNotifierListener,
    );
  }

  void _initTabs() {
    _updateTabs();

    _mainControllers.wordTypeController.addListener(() {
      _updateTabs();
    });
  }

  void _updateTabs() {
    final List<Tab> newTabs = [
      const Tab(text: "All"),
      const Tab(text: "Main"),
      if (NounFormsTab.shouldShowTab(_mainControllers.wordTypeController.value))
        const Tab(text: "Forms"),
      if (VerbFormsTab.shouldShowTab(_mainControllers.wordTypeController.value))
        const Tab(text: "Forms"),
      if (VerbPresentTenseTab.shouldShowTab(
        _mainControllers.wordTypeController.value,
      ))
        const Tab(text: "PresentTense"),
      if (VerbPastTenseTab.shouldShowTab(
        _mainControllers.wordTypeController.value,
      ))
        const Tab(text: "PastTense"),
      if (VerbImperativeTab.shouldShowTab(
        _mainControllers.wordTypeController.value,
      ))
        const Tab(text: "Imperative"),
      if (VerbPresentParticipleTab.shouldShowTab(
        _mainControllers.wordTypeController.value,
      ))
        const Tab(text: "PresentParticiple"),

      if (MetaTab.shouldShowTab(_mainControllers.wordTypeController.value))
        const Tab(text: "Meta"),
    ];

    final List<Widget> newTabViews = [
      _tab(_buildAllTab()),
      _tab(_buildMainTab()),
      if (NounFormsTab.shouldShowTab(_mainControllers.wordTypeController.value))
        _tab(_buildNounFormsTab()),
      if (VerbFormsTab.shouldShowTab(
        _mainControllers.wordTypeController.value,
      )) ...[
        _tab(_buildVerbFormsTab()),
        _tab(_buildVerbPresentTenseTab()),
        _tab(_buildVerbPastTenseTab()),
        _tab(_buildVerbImperativeTab()),
        _tab(_buildVerbPresentParticipleTab()),
      ],
      if (MetaTab.shouldShowTab(_mainControllers.wordTypeController.value))
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
          : 0,
    );
    setState(() {});
  }

  // When online translation is selected, apply its values to current word input fields
  void onlineTranslationSelectedNotifierAction(
    TranslationSearchResult? translation,
    List<GetWordGrammarOnlineResponse>? grammarOptions,
  ) {
    if (translation == null) {
      return;
    }

    // todo move it elsewhere, it does not belong to this layer
    final englishTranslations = translation.translationWords
        .where((w) => w.isSelected)
        .map((w) => w.value)
        .join(";");
    final contextExampleTranslation = translation
        .sentenceExamples
        .firstOrNull
        ?.englishSentence
        .replaceAll(RegExp(r'<[^>]*>'), '');
    final contextExample = translation
        .sentenceExamples
        .firstOrNull
        ?.dutchSentence
        .replaceAll(RegExp(r'<[^>]*>'), '');
    // end of todo

    setState(() {
      _mainControllers.dutchWordController.text = translation.mainWord;
      _mainControllers.wordTypeController.value =
          translation.partOfSpeech ?? PartOfSpeech.phrase;
      _mainControllers.englishWordController.text = englishTranslations;
      _mainControllers.contextExampleController.text = contextExample ?? "";
      _mainControllers.contextExampleTranslationController.text =
          contextExampleTranslation ?? "";

      _nounControllers.initializeFromTranslation(translation.nounDetails);
      _verbControllers.initializeFromTranslation(translation.verbDetails);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onlineTranslationSelectedNotifier.removeListener(
      _onlineTranslationSelectedNotifierListener,
    );
    _tabController.dispose();
    _mainControllers.wordTypeController.dispose();
    _tabsNotifier.dispose();
    _tabViewsNotifier.dispose();
  }

  Future<void> _initExistingWordAsync(int wordId) async {
    Word? existingWord = await _wordsRepository.getWordAsync(wordId);

    if (existingWord == null) {
      throw Exception("Failed to edit word with id '$wordId'");
    }

    _mainControllers.initializeFromWord(existingWord);
    _nounControllers.initializeFromDetails(existingWord.nounDetails);
    _verbControllers.initializeFromDetails(existingWord.verbDetails);

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
      child: SingleChildScrollView(child: child),
    );
  }

  Widget _buildAllTab() {
    return Column(
      children: [
        _buildMainTab(),
        if (NounFormsTab.shouldShowTab(
          _mainControllers.wordTypeController.value,
        ))
          _buildNounFormsTab(),
        if (VerbFormsTab.shouldShowTab(
          _mainControllers.wordTypeController.value,
        )) ...[
          _buildVerbFormsTab(),
          _buildVerbPresentTenseTab(),
          _buildVerbPastTenseTab(),
          _buildVerbImperativeTab(),
          _buildVerbPresentParticipleTab(),
        ],
        if (MetaTab.shouldShowTab(_mainControllers.wordTypeController.value))
          _buildMetaTab(),
      ],
    );
  }

  Widget _buildMainTab() {
    return MainTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      dutchWordController: _mainControllers.dutchWordController,
      englishWordController: _mainControllers.englishWordController,
      wordTypeValueNotifier: _mainControllers.wordTypeController,
      collectionValueNotifier: _mainControllers.wordCollectionController,
      deHetValueNotifier: _nounControllers.deHetType,
    );
  }

  Widget _buildNounFormsTab() {
    return NounFormsTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      dutchPluralFormController: _nounControllers.dutchPluralForm,
      diminutiveController: _nounControllers.diminutive,
    );
  }

  Widget _buildMetaTab() {
    return MetaTab(
      contextExampleController: _mainControllers.contextExampleController,
      contextExampleTranslationController:
          _mainControllers.contextExampleTranslationController,
      userNoteController: _mainControllers.userNoteController,
    );
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

  Widget _buildVerbFormsTab() {
    return VerbFormsTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      infinitiveController: _verbControllers.infinitive,
      completedParticipleController: _verbControllers.completedParticiple,
      auxiliaryVerbController: _verbControllers.auxiliaryVerb,
    );
  }

  Widget _buildVerbImperativeTab() {
    return VerbImperativeTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      imperativeInformalController: _verbControllers.imperative.informal,
      imperativeFormalController: _verbControllers.imperative.formal,
    );
  }

  Widget _buildVerbPresentParticipleTab() {
    return VerbPresentParticipleTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      presentParticipleUninflectedController:
          _verbControllers.presentParticiple.uninflected,
      presentParticipleInflectedController:
          _verbControllers.presentParticiple.inflected,
    );
  }

  Widget _buildVerbPresentTenseTab() {
    return VerbPresentTenseTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      presentTenseIkController: _verbControllers.presentTense.ik,
      presentTenseJijVraagController: _verbControllers.presentTense.jijVraag,
      presentTenseJijController: _verbControllers.presentTense.jij,
      presentTenseUController: _verbControllers.presentTense.u,
      presentTenseHijZijHetController: _verbControllers.presentTense.hijZijHet,
      presentTenseWijController: _verbControllers.presentTense.wij,
      presentTenseJullieController: _verbControllers.presentTense.jullie,
      presentTenseZijController: _verbControllers.presentTense.zij,
    );
  }

  Widget _buildVerbPastTenseTab() {
    return VerbPastTenseTab(
      wordTypeGetter: () => _mainControllers.wordTypeController.value,
      pastTenseIkController: _verbControllers.pastTense.ik,
      pastTenseJijController: _verbControllers.pastTense.jij,
      pastTenseHijZijHetController: _verbControllers.pastTense.hijZijHet,
      pastTenseWijController: _verbControllers.pastTense.wij,
      pastTenseJullieController: _verbControllers.pastTense.jullie,
      pastTenseZijController: _verbControllers.pastTense.zij,
    );
  }

  Widget _buildBody(BuildContext context) {
    return ValueListenableBuilder<List<Widget>>(
      valueListenable: _tabViewsNotifier,
      builder: (context, tabViews, _) {
        return TabBarView(controller: _tabController, children: tabViews);
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
              style: ButtonStyles.mediumPrimaryButtonStyle(
                context,
                fontWeight: FontWeight.bold,
              ),
              child: Text(getSubmitButtonLabel()),
            ),
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
    var wordCreatedNotifier = Provider.of<WordCreatedNotifier>(
      context,
      listen: false,
    );
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
    var newWord = ControllersToWordsMappingService.toNewWord(
      main: _mainControllers,
      noun: _nounControllers,
      verb: _verbControllers,
    );
    await _wordsRepository.addAsync(newWord);
  }

  Future<void> updateWordAsync() async {
    if (_isNewWord) return;

    var updatedWord = ControllersToWordsMappingService.toUpdatedWord(
      wordId: existingWordId!,
      main: _mainControllers,
      noun: _nounControllers,
      verb: _verbControllers,
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
