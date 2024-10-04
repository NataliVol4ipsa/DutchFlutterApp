// ignore_for_file: prefer_const_constructors
import 'package:first_project/reusable_widgets/generic_dropdown_menu.dart';
import 'package:first_project/word.dart';
import 'package:flutter/material.dart';

class NewWordInputPage extends StatefulWidget {
  const NewWordInputPage({super.key});

  @override
  State<NewWordInputPage> createState() => _NewWordInputPageState();
}

class _NewWordInputPageState extends State<NewWordInputPage> {
  TextEditingController dutchWordTextInputController = TextEditingController();
  TextEditingController englishWordTextInputController =
      TextEditingController();

  List<Word> words = [];

  WordType? selectedWordType = WordType.noun;

  void addNewWord() {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    setState(() {
      words.add(
          Word(dutchWordInput, englishWordInput, selectedWordType!, false));
      dutchWordTextInputController.text = "";
      englishWordTextInputController.text = "";
    });
  }

  void updateSelectedWordType(WordType? newValue) {
    setState(() {
      //selectedWordType = WordType.values.firstWhere((e) => e.name == newValue);
      selectedWordType = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new word')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: dutchWordTextInputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Dutch word",
                ),
              ),
              SizedBox(height: 10), // Add some spacing
              TextField(
                controller: englishWordTextInputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "English word",
                ),
              ),
              SizedBox(height: 20), // Add some spacing
              GenericDropdownMenu<WordType>(
                  dropdownValues: WordType.values.toList(),
                  onValueChanged: updateSelectedWordType,
                  displayString: (WordType? value) {
                    return value?.name ?? "";
                  }),
              SizedBox(height: 10), // Add some spacing
              ElevatedButton(onPressed: addNewWord, child: Text("Add")),
              SizedBox(height: 20), // Add some spacing
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
    );
  }
}
