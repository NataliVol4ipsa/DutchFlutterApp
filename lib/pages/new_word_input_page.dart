// ignore_for_file: prefer_const_constructors
import 'package:first_project/core/word_type.dart';
import 'package:first_project/models/db_context.dart';
import 'package:first_project/reusable_widgets/generic_dropdown_menu.dart';
import 'package:first_project/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> addNewWord() async {
    String dutchWordInput = dutchWordTextInputController.text;
    String englishWordInput = englishWordTextInputController.text;
    var newWord =
        Word(dutchWordInput, englishWordInput, selectedWordType!, false);
    var dbContext = context.read<DbContext>();
    await dbContext.addWordAsync(newWord);
    var dbWords = await dbContext.getWordsAsync();
    setState(() {
      //words.add(newWord);
      words = dbWords;
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

  String capitalizeEnum(WordType wordType) {
    final word = wordType.name;
    return '${word[0].toUpperCase()}${word.substring(1)}'; // Capitalize the first letter
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
              GenericDropdownMenu(
                  onValueChanged: updateSelectedWordType,
                  dropdownValues: WordType.values.toList(),
                  displayStringFunc: capitalizeEnum),
              SizedBox(height: 10), // Add some spacing
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
