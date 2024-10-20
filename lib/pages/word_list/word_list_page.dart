import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/services/words_io_json_v1_service.dart';
import 'package:first_project/core/services/words_storage_service.dart';
import 'package:first_project/pages/word_list/dialogs/delete_word_dialog.dart';
import 'package:first_project/pages/word_list/dialogs/export_words_dialog.dart';
import 'package:first_project/pages/word_list/snackbars/snackbar_shower.dart';
import 'package:first_project/pages/word_list/dialogs/word_editor_modal.dart';
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
    _captureScrollPosition();
    await _loadData();
    setState(() {
      selectAllCheckboxValue = false;
    });
    _restoreScrollPosition();
  }

  void _captureScrollPosition() {
    _scrollPosition = _scrollController.position.pixels;
  }

  void _restoreScrollPosition() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollPosition);
    }
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

  void toggleMultiSelectMode() {
    setState(() {
      isMultiselectModeEnabled = !isMultiselectModeEnabled;
    });
  }

  void onExportButtonPressed(BuildContext context) async {
    showExportDialog(context);
  }

  void showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExportWordsDialog(
          onExportPressed: exportWordsAsync,
        );
      },
    );
  }

  Future<void> exportWordsAsync(BuildContext context, String fileName) async {
    String path = await WordsIoJsonV1Service().exportAsync(words, fileName);
    if (!context.mounted) return;
    SnackbarShower.show(
        context, 'Successfully exported ${words.length} words to $path');
  }

  void onImportPressed(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["json"]);
    if (result == null) return null;

    WordsCollectionDtoV1 importedWords = await WordsIoJsonV1Service()
        .importAsync(File(result.files.first.path!));
    List<int> newWordsIds =
        await WordsStorageService(wordsRepository: wordsRepository)
            .storeInDatabaseAsync(importedWords);

    await _reloadDataAsync();
    if (!context.mounted) return;
    SnackbarShower.show(
        context, 'Successfully imported ${newWordsIds.length} words.');
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
            onPressed: () => onExportButtonPressed(context),
            icon: const Icon(Icons.file_download)),
        IconButton(
            onPressed: () => onImportPressed(context),
            icon: const Icon(Icons.upload_file)),
        IconButton(
          onPressed: toggleMultiSelectMode,
          icon: Icon(isMultiselectModeEnabled
              ? Icons.library_add_check
              : Icons.library_add_check_outlined),
        ),
      ],
    );
  }

  toggleRowCheckbox(index, value) {
    setState(() {
      selectedRows[index] = value!;
      updateSelectAllCheckboxValue();
    });
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: toggleMultiSelectMode,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: toggleMultiSelectMode,
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
    showDeleteWordDialog();
    await processWordDeletionAsync(context);
  }

  void showDeleteWordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> processWordDeletionAsync(BuildContext context) async {
    try {
      await _deleteWordsAsync();
    } catch (e) {
      print('Error during deletion: $e');
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      await _reloadDataAsync();
    }
  }

  void _onTableRowTap(BuildContext context, int index, Word word) async {
    if (isMultiselectModeEnabled) {
      toggleRowCheckbox(index, !selectedRows[index]);
    } else {
      await showWordEditor(context, word);
    }
  }

  Future<void> showWordEditor(BuildContext context, Word word) async {
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

// If new item is selected - check if selectAll value should change to select all, none or some
  void updateSelectAllCheckboxValue() {
    if (selectedRows.every((isSelected) => isSelected)) {
      selectAllCheckboxValue = true;
    } else if (selectedRows.every((isSelected) => !isSelected)) {
      selectAllCheckboxValue = false;
    } else {
      selectAllCheckboxValue = null;
    }
  }

// If someone clicks on select all checkbox - update state accordingly
  void onSelectAllCheckboxValueChanged2(bool? isSelected) {
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

  @override
  Widget build(BuildContext context) {
    // PopScope Allows to override back button behavior
    return PopScope(
      canPop: true,
      onPopInvoked: onPopAsync,
      child: Scaffold(
        appBar: createAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : WordTable(
                  words: words,
                  selectedRows: selectedRows,
                  isMultiselectModeEnabled: isMultiselectModeEnabled,
                  selectAllCheckboxValue: selectAllCheckboxValue,
                  scrollController: _scrollController,
                  onRowCheckboxChanged: toggleRowCheckbox,
                  onSelectAllCheckboxValueChanged:
                      onSelectAllCheckboxValueChanged2,
                  onRowTap: (index, word) {
                    _onTableRowTap(context, index, word);
                  },
                  onRowLongPress: (int ind) {
                    if (!isMultiselectModeEnabled) {
                      toggleMultiSelectMode();
                    }

                    toggleRowCheckbox(ind, true);
                  },
                ),
        ),
        bottomNavigationBar: isMultiselectModeEnabled
            ? createMultiselectBottomNavBar(context)
            : null,
      ),
    );
  }

  Future<void> onPopAsync(bool didPop) async {
    if (isMultiselectModeEnabled) {
      toggleMultiSelectMode();
      return;
    }
  }
}
