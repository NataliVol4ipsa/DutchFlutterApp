// ignore_for_file: prefer_const_constructors
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

  WordType selectedWordType = WordType.noun;

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

  void updateSelectedWordType(String? newValue) {
    setState(() {
      selectedWordType = WordType.values.firstWhere((e) => e.name == newValue);
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
              WordTypeDropdownMenu(onValueChanged: updateSelectedWordType),
              SizedBox(height: 10), // Add some spacing
              ElevatedButton(onPressed: addNewWord, child: Text("Add")),
              SizedBox(height: 20), // Add some spacing
              // Wrap ListView.builder in Expanded to provide height
              Expanded(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return ListTile(
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

class WordTypeDropdownMenu extends StatefulWidget {
  final ValueChanged<String?> onValueChanged;

  const WordTypeDropdownMenu({required this.onValueChanged});

  @override
  State<WordTypeDropdownMenu> createState() => _WordTypeDropdownMenuState();
}

class _WordTypeDropdownMenuState extends State<WordTypeDropdownMenu> {
  List<String> dropdownValues = WordType.values.map((e) => e.name).toList();
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = dropdownValues.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: dropdownValues.first,
      onSelected: (String? value) {
        setState(() {
          selectedValue = value!;
          widget.onValueChanged(selectedValue);
        });
      },
      dropdownMenuEntries:
          dropdownValues.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
