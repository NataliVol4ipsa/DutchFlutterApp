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
  bool showSelectColumn = false;
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
      showSelectColumn = !showSelectColumn;
    });
  }

  void onSelectAllCheckboxValueChanged(bool? isSelected) {
    bool newValue = isSelected == false ? true : false;
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

  generateTableColWidths() {
    if (showSelectColumn) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word list'),
        actions: <Widget>[
          IconButton(
            onPressed: onMultiselectModeButtonPressed,
            icon: Icon(showSelectColumn
                ? Icons.library_add_check
                : Icons.library_add_check_outlined),
          ),
        ],
      ),
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
                  if (showSelectColumn) ...[
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
                    if (showSelectColumn) ...[
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
