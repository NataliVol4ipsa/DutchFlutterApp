import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/services/words_io_json_v1_service.dart';
import 'package:first_project/core/services/words_storage_service.dart';
import 'package:first_project/pages/word_list/delete_word_dialog.dart';
import 'package:first_project/pages/word_list/word_editor_modal.dart';
import 'package:first_project/pages/word_list/word_list_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../local_db/repositories/words_repository.dart';

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

  late ScrollController _scrollController;
  double _scrollPosition = 0.0;

  late WordsRepository wordsRepository;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollPosition = _scrollController.position.pixels;
    });
    wordsRepository = context.read<WordsRepository>();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _reloadDataAsync() async {
    await _loadData();
    setState(() {
      selectAllCheckboxValue = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollPosition);
    });
  }

  Future<void> _fetchWordsAsync() async {
    var dbWords = await wordsRepository.fetchWordsAsync();

    setState(() {
      words = dbWords;
    });
    postWordsFetchInit();
  }

  Future<void> _deleteWordsAsync() async {
    var selectedWordsIds = getSelectedWordsIds();
    await wordsRepository.deleteWordsAsync(selectedWordsIds);
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

  void onExportPressed(BuildContext context) async {
    String path = await WordsIoJsonV1Service().exportAsync(words, "test");
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully exported ${words.length} words to $path'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void onImportPressed(BuildContext context) async {
    WordsCollectionDtoV1 importedWords =
        await WordsIoJsonV1Service().importAsync("test");
    List<int> newWordsIds =
        await WordsStorageService(wordsRepository: wordsRepository)
            .storeInDatabaseAsync(importedWords);

    await _reloadDataAsync();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully imported ${newWordsIds.length} words.'),
        duration: const Duration(seconds: 3),
      ),
    );
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
            onPressed: () => onExportPressed(context),
            icon: const Icon(Icons.file_download)),
        IconButton(
            onPressed: () => onImportPressed(context),
            icon: const Icon(Icons.upload_file)),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteWordDialog(
          onDeletePressed: () => _onDeletePressed(context),
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

  void _onTableRowTap(BuildContext context, Word word) async {
    if (isMultiselectModeEnabled) return;

    await WordEditorModal.show(
      context: context,
      word: word,
    );

    await _reloadDataAsync();
  }

  BottomNavigationBar createMultiselectBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }

  GestureDetector createTappableTableCell(
      BuildContext context, Word word, String value) {
    return GestureDetector(
      onTap: () {
        _onTableRowTap(context, word);
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
                controller: _scrollController,
                child: WordTable(
                  words: words,
                  selectedRows: selectedRows,
                  isMultiselectModeEnabled: isMultiselectModeEnabled,
                  selectAllCheckboxValue: selectAllCheckboxValue,
                  onRowCheckboxChanged: onRowCheckboxChanged,
                  onSelectAllCheckboxValueChanged:
                      onSelectAllCheckboxValueChanged,
                  onRowTap: (Word word) => _onTableRowTap(context, word),
                ),
              ),
      ),
      bottomNavigationBar: isMultiselectModeEnabled
          ? createMultiselectBottomNavBar(context)
          : null,
    );
  }
}
