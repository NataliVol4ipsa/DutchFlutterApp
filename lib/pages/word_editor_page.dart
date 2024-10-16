// ignore_for_file: prefer_const_constructors
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/reusable_widgets/generic_dropdown_menu.dart';
import 'package:first_project/reusable_widgets/optional_toggle_buttons.dart';
import 'package:first_project/reusable_widgets/models/toggle_button_item.dart';
import 'package:first_project/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/input_label.dart';

class NewWordInputPage extends StatefulWidget {
  const NewWordInputPage({super.key});

  @override
  State<NewWordInputPage> createState() => _NewWordInputPageState();
}

class _NewWordInputPageState extends State<NewWordInputPage> {
  TextEditingController dutchWordTextInputController = TextEditingController();
  TextEditingController englishWordTextInputController =
      TextEditingController();
  TextEditingController dutchPluralFormTextInputController =
      TextEditingController();
  FocusNode dutchWordFocusNode =
      FocusNode(); // To switch focus to dutch input field after clicking Add

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Word> words = [];

  WordType? selectedWordType = WordType.none;
  DeHetType? selectedDeHetType = DeHetType.none;

  Future<void> addNewWord() async {
    if (!_formKey.currentState!.validate()) return;
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    String dutchPluralFormWordInput = dutchPluralFormTextInputController.text;

// todo use newWord model instead?
    var newWord = Word(
        null, dutchWordInput, englishWordInput, selectedWordType!,
        deHet: selectedDeHetType!, pluralForm: dutchPluralFormWordInput);

    var dbContext = context.read<DbContext>();
    await dbContext.addWordAsync(newWord);
    var dbWords = await dbContext.getWordsAsync();

    setState(() {
      _formKey.currentState!.reset(); //todo
      words = dbWords;
      dutchWordTextInputController.text = "";
      englishWordTextInputController.text = "";
      dutchPluralFormTextInputController.text = "";
      selectedDeHetType = DeHetType.none;
      dutchWordFocusNode.requestFocus();
    });
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

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    var dbContext = context.read<DbContext>();
    var dbWords = await dbContext.getWordsAsync();
    setState(() {
      words = dbWords;
    });
  }

  String capitalizeEnum(Enum value) {
    final word = value.name;
    return '${word[0].toUpperCase()}${word.substring(1)}'; // Capitalize the first letter
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
    // Be sure to dispose the FocusNode when the widget is removed from the tree
    dutchWordFocusNode.dispose();
    super.dispose();
  }

  Widget customPadding() => SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new word')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: InputLabel(
                      "Word type",
                    )),
                GenericDropdownMenu(
                    onValueChanged: updateSelectedWordType,
                    dropdownValues: WordType.values.toList(),
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
                  focusNode: dutchWordFocusNode, // Attach FocusNode
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
                ElevatedButton(onPressed: addNewWord, child: Text("Add word")),
                SizedBox(height: 20),
                // Wrap ListView.builder in Expanded to provide height
                Expanded(
                  child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        visualDensity: VisualDensity(vertical: -4.0),
                        title: Text(
                            "[${words[index].type.name}] ${words[index].dutchWord}: ${words[index].englishWord}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
