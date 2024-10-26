import 'package:first_project/core/http_clients/get_word_online_response.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';
import 'package:first_project/pages/words_editor/online_word_search_section.dart';
import 'package:first_project/reusable_widgets/generic_dropdown_menu.dart';
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
  TextEditingController dutchWordTextInputController = TextEditingController();
  TextEditingController englishWordTextInputController =
      TextEditingController();
  TextEditingController dutchPluralFormTextInputController =
      TextEditingController();
  FocusNode dutchWordFocusNode =
      FocusNode(); // To switch focus to dutch input field after clicking Add

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  WordType? selectedWordType;
  DeHetType? selectedDeHetType = DeHetType.none;

  bool isNewWord = false;
  bool resetSearchTrigger = false;

  List<WordType> wordTypeDropdownValues = WordType.values.toList();

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
    dutchWordTextInputController.text = word.dutchWord;
    englishWordTextInputController.text = word.englishWord;
    dutchPluralFormTextInputController.text = word.pluralForm ?? "";
    selectedDeHetType = word.deHetType;
  }

  Future<void> submitChangesAsync() async {
    if (!_formKey.currentState!.validate()) return;
    if (isNewWord) {
      await createWordAsync();
      resetSearchTrigger = !resetSearchTrigger;
    } else {
      await updateWordAsync();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> createWordAsync() async {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var newWord = Word(
        null, dutchWordInput, englishWordInput, selectedWordType!,
        deHetType: selectedDeHetType!, pluralForm: dutchPluralFormWordInput);

    await wordsRepository.addWordAsync(newWord);

    setState(() {
      _formKey.currentState!.reset(); //todo
      dutchWordTextInputController.text = "";
      englishWordTextInputController.text = "";
      dutchPluralFormTextInputController.text = "";
      selectedDeHetType = DeHetType.none;
      dutchWordFocusNode.requestFocus();
    });
  }

  Future<void> updateWordAsync() async {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

    var updatedWord = Word(widget.existingWord!.id, dutchWordInput,
        englishWordInput, selectedWordType!,
        deHetType: selectedDeHetType!, pluralForm: dutchPluralFormWordInput);

    await wordsRepository.updateWordAsync(updatedWord);
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

  void updateSelectedDeHetType(DeHetType? newValue) {
    setState(() {
      selectedDeHetType = newValue;
    });
  }

  String capitalizeEnum(Enum value) {
    final word = value.name;
    return '${word[0].toUpperCase()}${word.substring(1)}';
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
    dutchWordFocusNode.dispose();
    super.dispose();
  }

  Widget customPadding() => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getAppBarLabel())),
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
                GenericDropdownMenu(
                    initialValue: selectedWordType,
                    onValueChanged: updateSelectedWordType,
                    dropdownValues: wordTypeDropdownValues,
                    displayStringFunc: capitalizeEnum),
                customPadding(),
                Container(
                    alignment: Alignment.centerLeft,
                    child: const InputLabel(
                      "Dutch",
                      isRequired: true,
                    )),
                TextFormField(
                  controller: dutchWordTextInputController,
                  focusNode: dutchWordFocusNode,
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
