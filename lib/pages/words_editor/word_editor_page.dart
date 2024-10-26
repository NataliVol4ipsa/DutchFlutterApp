// ignore_for_file: prefer_const_constructors
import 'package:first_project/core/http_clients/get_word_online_response.dart';
import 'package:first_project/core/http_clients/woordenlijst_client.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';
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
    } else {
      await updateWordAsync();
      if (mounted) {
        Navigator.of(context).pop();
      }
      resetSearchComplete();
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

// =============================== search online section

  bool searchComplete = false;

  List<GetWordOnlineResponse>? onlineWordOptions;

  onSearchWordOnlineClicked() async {
    setState(() {
      searchComplete = false;
    });
    var response = await WoordenlijstClient().findAsync(
        dutchWordTextInputController.text,
        wordType: selectedWordType);

    onlineWordOptions = response.onlineWords;
    setState(() {
      searchComplete = true;
    });
  }

  void resetSearchComplete() {
    setState(() {
      searchComplete = false;
    });
  }

// ===============================

  @override
  void dispose() {
    dutchWordFocusNode.dispose();
    super.dispose();
  }

  Widget customPadding() => SizedBox(height: 10);

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
                    child: InputLabel(
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
                    child: InputLabel(
                      "Dutch",
                      isRequired: true,
                    )),
                TextFormField(
                  controller: dutchWordTextInputController,
                  focusNode: dutchWordFocusNode,
                  decoration: InputDecoration(
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
                  if (searchComplete) ...{
                    if (onlineWordOptions == null ||
                        onlineWordOptions!.isEmpty) ...{
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.red[50],
                              child: Row(
                                children: const [
                                  Icon(Icons.error, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    "Failed to find word online",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ])),
                      customPadding(),
                    },
                    if (onlineWordOptions != null &&
                        onlineWordOptions!.isNotEmpty) ...{
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Disable internal scrolling to avoid conflicts
                        itemCount: onlineWordOptions?.length ?? 0,
                        itemBuilder: (context, index) {
                          final wordOption = onlineWordOptions![index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wordOption.word,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  if (wordOption.partOfSpeech != null)
                                    Text(
                                        'Part of Speech: ${capitalizeEnum(wordOption.partOfSpeech!)}'),
                                  if (wordOption.gender != null)
                                    Text(
                                        'De/Het: ${capitalizeEnum(wordOption.gender!)}'),
                                  if (wordOption.pluralForm != null)
                                    Text('Plural: ${wordOption.pluralForm}'),
                                  if (wordOption.diminutive != null)
                                    Text(
                                        'Diminutive: ${wordOption.diminutive}'),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Handle Apply button press
                                      },
                                      child: Text('Apply'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    }
                  },
                  ValueListenableBuilder(
                    valueListenable: dutchWordTextInputController,
                    builder: (context, TextEditingValue value, child) {
                      return ElevatedButton(
                        onPressed: value.text.trim() == ""
                            ? null
                            : onSearchWordOnlineClicked,
                        child: Text("Search word online"),
                      );
                    },
                  ),
                  customPadding(),
                },
                Container(
                    alignment: Alignment.centerLeft,
                    child: InputLabel(
                      "English",
                      isRequired: true,
                    )),
                TextFormField(
                  controller: englishWordTextInputController,
                  decoration: InputDecoration(
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
                      child: InputLabel(
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
                      child: InputLabel(
                        "Dutch plural form",
                      )),
                  TextField(
                    controller: dutchPluralFormTextInputController,
                    decoration: InputDecoration(
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
