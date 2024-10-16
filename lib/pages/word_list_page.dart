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
  bool _isLoading = true;

  List<Word> words = [];
  List<bool> selectedRows = [];
  bool isMultiselectModeEnabled = false;
  bool? selectAllCheckboxValue = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _fetchWordsAsync();

    postWordsFetchInit();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchWordsAsync() async {
    var dbContext = context.read<DbContext>();
    var dbWords = await dbContext.getWordsAsync();
    setState(() {
      words = dbWords;
    });
    postWordsFetchInit();
  }

  Future<void> _deleteWordsAsync() async {
    var dbContext = context.read<DbContext>();
    var selectedWordsIds = getSelectedWordsIds();
    await dbContext.deleteBatchAsync(selectedWordsIds);
  }

  List<int> getSelectedWordsIds() {
    List<int> selectedIds = [];

    for (int i = 0; i < words.length; i++) {
      if (selectedRows[i] && words[i].id != null) {
        selectedIds.add(words[i].id!);
      }
    }

    return selectedIds;
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

// DOM
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

  AppBar createAppBar() {
    if (!isMultiselectModeEnabled) {
      return createNormalAppBar();
    }
    return createMultiselectAppBar();
  }

  AppBar createNormalAppBar() {
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

  AppBar createMultiselectAppBar() {
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

// Modal
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete following items?'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This action is permanent.'),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(
                      height: 30,
                      child: VerticalDivider(thickness: 1, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _onDeletePressed(context);
                      },
                      child: const Text('DELETE',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onDeletePressed(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await _deleteWordsAsync();
    } catch (e) {
      print('Error during deletion: $e');
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      await _loadData();
    }
  }

  void _onRowTap(BuildContext context, Word word) {
    if (isMultiselectModeEnabled) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: WordDetailsPage(word: word),
        );
      },
    );
  }

  GestureDetector createTappableTableCell(
      BuildContext context, Word word, String value) {
    return GestureDetector(
      onTap: () {
        _onRowTap(context, word);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: createTappableTableCell(
                                context, word, index.toString()),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: createTappableTableCell(
                                context, word, word.dutchWord),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: createTappableTableCell(
                                context, word, word.englishWord),
                          ),
                          if (isMultiselectModeEnabled) ...[
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: Checkbox(
                                    value: selectedRows[entry.key],
                                    onChanged: (isSelected) =>
                                        onRowCheckboxChanged(
                                            entry.key, isSelected),
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
      bottomNavigationBar: isMultiselectModeEnabled
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: zeroCheckboxesSelected()
                        ? const Icon(Icons.school_outlined)
                        : const Icon(Icons.school),
                    label: 'Practice'),
                BottomNavigationBarItem(
                  icon: zeroCheckboxesSelected()
                      ? const Icon(Icons.delete_outline)
                      : const Icon(Icons.delete),
                  label: 'Delete',
                ),
              ],
              onTap: (int index) {
                if (zeroCheckboxesSelected()) return;
                switch (index) {
                  case 0:
                    break;
                  case 1: // Delete
                    _showDeleteDialog(context);
                    break;
                }
              },
            )
          : null,
    );
  }
}

class WordDetailsPage extends StatelessWidget {
  final Word word;

  WordDetailsPage({required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("Dutch : ${word.dutchWord}"),
      ),
    );
  }
}
