import 'package:first_project/core/models/new_word.dart';
import 'package:first_project/core/models/word_collection.dart';
import 'package:first_project/http_clients/get_word_online_response.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';
import 'package:first_project/pages/word_editor/online_word_search_section.dart';
import 'package:first_project/reusable_widgets/dropdowns/word_collection_dropdown.dart';
import 'package:first_project/reusable_widgets/dropdowns/word_type_dropdown.dart';
import 'package:first_project/reusable_widgets/my_app_bar_widget.dart';
import 'package:first_project/reusable_widgets/optional_toggle_buttons.dart';
import 'package:first_project/reusable_widgets/models/toggle_button_item.dart';
import 'package:first_project/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../reusable_widgets/input_label.dart';

class WordEditorPage extends StatefulWidget {
  final Word? existingWord;
  const WordEditorPage({super.key, this.existingWord});

  @override
  State<WordEditorPage> createState() => _WordEditorPageState();
}

class _WordEditorPageState extends State<WordEditorPage> {
  Key key = UniqueKey();

  TextEditingController dutchWordTextInputController = TextEditingController();
  TextEditingController englishWordTextInputController =
      TextEditingController();
  TextEditingController dutchPluralFormTextInputController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  WordType? selectedWordType;
  WordCollection? selectedWordCollection;
  DeHetType? selectedDeHetType = DeHetType.none;

  bool isNewWord = false;
  bool resetSearchTrigger = false;

  late WordsRepository wordsRepository;

  @override
  void initState() {
    super.initState();
    wordsRepository = context.read<WordsRepository>();
    isNewWord = widget.existingWord == null;
    if (!isNewWord) {
      initializeWithExistingWord(widget.existingWord!);
    }
    selectedWordType ??= WordType.none;
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
    if (isNewWord) {
      await createWordAsync();
      recreatePage();
    } else {
      await updateWordAsync();
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

  void onApplyOnlineWordPressed(GetWordOnlineResponse wordOption) {
    setState(() {
      resetSearchTrigger = !resetSearchTrigger;
      selectedWordType = wordOption.partOfSpeech ?? WordType.none;
      dutchPluralFormTextInputController.text = wordOption.pluralForm ?? "";
      selectedDeHetType = wordOption.gender ?? DeHetType.none;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget customPadding() => const SizedBox(height: 10);

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
                Container(
                    alignment: Alignment.centerLeft,
                    child: const InputLabel(
                      "Word type",
                    )),
                WordTypeDropdown(
                  initialValue: selectedWordType,
                  updateValueCallback: updateSelectedWordType,
                ),
                customPadding(),
                Container(
                    alignment: Alignment.centerLeft,
                    child: const InputLabel(
                      "Collection",
                    )),
                WordCollectionDropdown(
                  initialValue: selectedWordCollection,
                  updateValueCallback: updateSelectedWordCollection,
                ),
                customPadding(),
                Container(
                    alignment: Alignment.centerLeft,
                    child: const InputLabel(
                      "Dutch",
                      isRequired: true,
                    )),
                TextFormField(
                  controller: dutchWordTextInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Dutch word",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Dutch word is required';
                    }
                    return null;
                  },
                ),
                customPadding(),
                if (isNewWord) ...{
                  OnlineWordSearchSection(
                    dutchWordTextInputController: dutchWordTextInputController,
                    selectedWordType: selectedWordType,
                    onApplyOnlineWordPressed: onApplyOnlineWordPressed,
                    resetTrigger: resetSearchTrigger,
                  ),
                },
                Container(
                    alignment: Alignment.centerLeft,
                    child: const InputLabel(
                      "English",
                      isRequired: true,
                    )),
                TextFormField(
                  controller: englishWordTextInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "English word",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'English word is required';
                    }
                    return null;
                  },
                ),
                customPadding(),
                if (shouldDisplayDeHetInput()) ...[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: const InputLabel(
                        "De/Het type",
                      )),
                  OptionalToggleButtons<DeHetType?>(
                    items: [
                      ToggleButtonItem(label: 'De', value: DeHetType.de),
                      ToggleButtonItem(label: 'Het', value: DeHetType.het),
                    ],
                    onChanged: onDeHetToggleChanged,
                    selectedValue: selectedDeHetType,
                  ),
                ],
                customPadding(),
                if (shouldDisplayPluralFormInput()) ...[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: const InputLabel(
                        "Dutch plural form",
                      )),
                  TextField(
                    controller: dutchPluralFormTextInputController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Dutch plural form",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                ],
                customPadding(),
                ElevatedButton(
                    onPressed: submitChangesAsync,
                    child: Text(getSubmitButtonLabel())),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
