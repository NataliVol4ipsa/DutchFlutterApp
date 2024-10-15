import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  List<Word> words = [];
  List<bool> selectedRows = [];
  bool isMultiselectModeEnabled = false;
  bool? selectAllCheckboxValue = false;

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
    postWordsFetchInit();
  }

  void postWordsFetchInit() {
    selectedRows = List.generate(words.length, (index) => false);
  }

  void onMultiselectModeButtonPressed() {
    setState(() {
      isMultiselectModeEnabled = !isMultiselectModeEnabled;
    });
  }

  void onSelectAllCheckboxValueChanged(bool? isSelected) {
    bool newValue;
    if (selectAllCheckboxValue == null) {
      newValue = true;
    } else if (isSelected == null) {
      newValue = false;
    } else {
      newValue = isSelected;
    }
    setState(() {
      selectAllCheckboxValue = newValue;
      selectedRows = List.generate(words.length, (index) => newValue);
    });
  }

  void onRowCheckboxChanged(int index, bool? isSelected) {
    bool newRowValue = isSelected ?? false;
    setState(() {
      selectedRows[index] = newRowValue;
      selectAllCheckboxValue = calculateNewSelectAllValue();
    });
  }

  bool? calculateNewSelectAllValue() {
    return allCheckboxesSelected()
        ? true
        : zeroCheckboxesSelected()
            ? false
            : null;
  }

  bool allCheckboxesSelected() {
    for (int i = 0; i < words.length; i++) {
      if (selectedRows[i] == false) return false;
    }
    return true;
  }

  bool zeroCheckboxesSelected() {
    for (int i = 0; i < words.length; i++) {
      if (selectedRows[i] == true) return false;
    }
    return true;
  }

  int calculateNumOfSelectedItems() {
    int result = 0;
    for (int i = 0; i < words.length; i++) {
      if (selectedRows[i] == true) {
        result++;
      }
    }

    return result;
  }

  generateTableColWidths() {
    if (isMultiselectModeEnabled) {
      return {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(10),
        2: const FlexColumnWidth(10),
        3: const FlexColumnWidth(2),
      };
    }
    return {
      0: const FlexColumnWidth(2),
      1: const FlexColumnWidth(10),
      2: const FlexColumnWidth(10),
    };
  }

  AppBar createViewAppBar() {
    if (!isMultiselectModeEnabled) {
      return AppBar(
        title: const Text('Word list'),
        actions: <Widget>[
          IconButton(
            onPressed: onMultiselectModeButtonPressed,
            icon: Icon(isMultiselectModeEnabled
                ? Icons.library_add_check
                : Icons.library_add_check_outlined),
          ),
        ],
      );
    }
    var numOfSelectedItems = calculateNumOfSelectedItems();
    String appBarText;
    switch (numOfSelectedItems) {
      case 0:
        appBarText = "None selected";
      case 1:
        appBarText = "1 item selected";
      default:
        appBarText = "$numOfSelectedItems items selected";
    }
    return AppBar(
      title: Text(appBarText),
      actions: <Widget>[
        IconButton(
          onPressed: onMultiselectModeButtonPressed,
          icon: Icon(isMultiselectModeEnabled
              ? Icons.library_add_check
              : Icons.library_add_check_outlined),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createViewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(), // Adds border around the table and cells
            columnWidths: generateTableColWidths(),
            children: [
              TableRow(
                children: [
                  const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Dutch',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'English',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isMultiselectModeEnabled) ...[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Checkbox(
                          tristate: true,
                          value: selectAllCheckboxValue,
                          onChanged: onSelectAllCheckboxValueChanged,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              ...words.asMap().entries.map((entry) {
                int index = entry.key + 1;
                Word word = entry.value;
                return TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(index.toString()),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(word.dutchWord),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(word.englishWord),
                      ),
                    ),
                    if (isMultiselectModeEnabled) ...[
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Checkbox(
                              value: selectedRows[entry.key],
                              onChanged: (isSelected) =>
                                  onRowCheckboxChanged(entry.key, isSelected),
                            ),
                          )),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
