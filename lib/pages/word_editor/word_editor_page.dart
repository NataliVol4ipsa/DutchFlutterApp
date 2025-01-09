import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/core/notifiers/online_word_search_suggestion_selected_notifier.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:dutch_app/http_clients/get_word_online_response.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';
import 'package:dutch_app/pages/word_editor/inputs/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/padded_form_component_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_word_search_modal.dart';
import 'package:dutch_app/pages/word_editor/validation_functions.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_collection_dropdown.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_type_dropdown.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/reusable_widgets/optional_toggle_buttons.dart';
import 'package:dutch_app/reusable_widgets/models/toggle_button_item.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordEditorPage extends StatefulWidget {
  final Word? existingWord;
  const WordEditorPage({super.key, this.existingWord});

  @override
  State<WordEditorPage> createState() => _WordEditorPageState();
}

class _WordEditorPageState extends State<WordEditorPage> {
  Key key = UniqueKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dutchWordTextInputController = TextEditingController();
  TextEditingController englishWordTextInputController =
      TextEditingController();
  TextEditingController dutchPluralFormTextInputController =
      TextEditingController();

  WordType? selectedWordType;
  WordCollection? selectedWordCollection;
  DeHetType? selectedDeHetType = DeHetType.none;

  bool isNewWord = false;
  bool resetSearchTrigger = false;

  late WordsRepository wordsRepository;
  late OnlineWordSearchSuggestionSelectedNotifier onlineWordSelectedNotifier;

  @override
  void initState() {
    super.initState();
    onlineWordSelectedNotifier =
        context.read<OnlineWordSearchSuggestionSelectedNotifier>();
    onlineWordSelectedNotifier.addListener(() {
      onlineWordSelectedNotifierAction(onlineWordSelectedNotifier.wordOption);
    });
    wordsRepository = context.read<WordsRepository>();
    isNewWord = widget.existingWord == null;
    if (!isNewWord) {
      initializeWithExistingWord(widget.existingWord!);
    }
    selectedWordType ??= WordType.none;
  }

  void onlineWordSelectedNotifierAction(GetWordOnlineResponse? wordOption) {
    if (wordOption == null) {
      return;
    }
    setState(() {
      resetSearchTrigger = !resetSearchTrigger;
      selectedWordType = wordOption.partOfSpeech ?? WordType.none;
      dutchPluralFormTextInputController.text = wordOption.pluralForm ?? "";
      selectedDeHetType = wordOption.gender ?? DeHetType.none;
    });
  }

  void initializeWithExistingWord(Word word) {
    selectedWordType = word.wordType;
    selectedWordCollection = word.collection;
    dutchWordTextInputController.text = word.dutchWord;
    englishWordTextInputController.text = word.englishWord;
    dutchPluralFormTextInputController.text = word.pluralForm ?? "";
    selectedDeHetType = word.deHetType;
  }

  Future<void> submitChangesAsync() async {
    if (!_formKey.currentState!.validate()) return;
    var notifier = Provider.of<WordCreatedNotifier>(context, listen: false);
    if (isNewWord) {
      notifyWordCreated(context);
      await createWordAsync();
      notifier.notify();
      recreatePage();
    } else {
      await updateWordAsync();
      notifier.notify();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void recreatePage() {
    Navigator.pushReplacement(
      context,
      NoAnimationPageRoute(
        builder: (context) => WordEditorPage(
          key: UniqueKey(),
          existingWord: widget.existingWord,
        ),
      ),
    );
  }

  Future<void> createWordAsync() async {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var newWord = NewWord(dutchWordInput, englishWordInput, selectedWordType!,
        deHetType: selectedDeHetType!,
        pluralForm: dutchPluralFormWordInput,
        collection: selectedWordCollection);

    await wordsRepository.addAsync(newWord);
  }

  Future<void> updateWordAsync() async {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var updatedWord = Word(widget.existingWord!.id, dutchWordInput,
        englishWordInput, selectedWordType!,
        deHetType: selectedDeHetType!,
        pluralForm: dutchPluralFormWordInput,
        collection: selectedWordCollection);

    await wordsRepository.updateAsync(updatedWord);
//todo make this an input method - what to do when action is complete. Accept new or close the page.
  }

  String getAppBarLabel() {
    if (isNewWord) return 'Add new word';
    return 'Edit word';
  }

  String getSubmitButtonLabel() {
    if (isNewWord) return 'Add word';
    return 'Save changes';
  }

  void updateSelectedWordType(WordType? newValue) {
    setState(() {
      selectedWordType = newValue;
    });
  }

  void updateSelectedWordCollection(WordCollection newValue) {
    selectedWordCollection = newValue;
  }

  void updateSelectedDeHetType(DeHetType? newValue) {
    setState(() {
      selectedDeHetType = newValue;
    });
  }

  bool shouldDisplayDeHetInput() {
    return selectedWordType == WordType.noun;
  }

  bool shouldDisplayPluralFormInput() {
    return selectedWordType == WordType.noun;
  }

  void onDeHetToggleChanged(DeHetType? selectedValue) {
    selectedValue ??= DeHetType.none;
    setState(() {
      selectedDeHetType = selectedValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget customPadding() => const SizedBox(height: 10);

  Widget _buildSearchSuffixIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dutchWordTextInputController.text.trim() == "") return;
        OnlineWordSearchModal.show(context, dutchWordTextInputController.text);
      },
      child: Icon(Icons.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(getAppBarLabel()),
        disableSettingsButton: widget.existingWord != null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PaddedFormComponent(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FormInput(
                            inputLabel: "Word type",
                            child: WordTypeDropdown(
                              initialValue: selectedWordType,
                              updateValueCallback: updateSelectedWordType,
                            )),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Expanded(
                        child: FormInput(
                          inputLabel: "Collection",
                          child: WordCollectionDropdown(
                            initialValue: selectedWordCollection,
                            updateValueCallback: updateSelectedWordCollection,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PaddedFormComponent(
                  child: FormTextInput(
                    textInputController: dutchWordTextInputController,
                    inputLabel: "Dutch",
                    hintText: "Dutch word",
                    isRequired: true,
                    valueValidator: nonEmptyString,
                    invalidInputErrorMessage: "Dutch word is required",
                    suffixIcon: _buildSearchSuffixIcon(context),
                  ),
                ),
                PaddedFormComponent(
                  child: FormTextInput(
                      textInputController: englishWordTextInputController,
                      inputLabel: "English",
                      hintText: "English word",
                      isRequired: true,
                      valueValidator: nonEmptyString,
                      invalidInputErrorMessage: "English word is required"),
                ),
                if (shouldDisplayDeHetInput()) ...[
                  PaddedFormComponent(
                    child: FormInput(
                      inputLabel: "De/Het type",
                      child: OptionalToggleButtons<DeHetType?>(
                        items: [
                          ToggleButtonItem(label: 'De', value: DeHetType.de),
                          ToggleButtonItem(label: 'Het', value: DeHetType.het),
                        ],
                        onChanged: onDeHetToggleChanged,
                        selectedValue: selectedDeHetType,
                      ),
                    ),
                  ),
                ],
                if (shouldDisplayPluralFormInput()) ...[
                  PaddedFormComponent(
                    child: FormTextInput(
                        textInputController: dutchPluralFormTextInputController,
                        inputLabel: "Dutch plural form",
                        hintText: "Dutch plural form",
                        isRequired: false),
                  ),
                ],
                //todo redesign
                PaddedFormComponent(
                  child: ElevatedButton(
                      onPressed: submitChangesAsync,
                      child: Text(getSubmitButtonLabel())),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// todo move out and explain what it does
class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  NoAnimationPageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: Duration.zero, // No animation
          reverseTransitionDuration: Duration.zero, // No reverse animation
        );
}
