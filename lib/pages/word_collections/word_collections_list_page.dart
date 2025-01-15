import 'dart:io';

import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:dutch_app/core/services/words_storage_service.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';
import 'package:dutch_app/io/v1/words_io_json_service_v1.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/pages/word_collections/dialogs/add_collection_dialog.dart';
import 'package:dutch_app/pages/word_collections/dialogs/delete_word_dialog.dart';
import 'package:dutch_app/pages/word_collections/dialogs/export_data_dialog.dart';
import 'package:dutch_app/pages/word_collections/popup_menu_item_widget.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';
import 'package:dutch_app/pages/word_collections/selectable_word_widget.dart';
import 'package:dutch_app/pages/word_collections/selectable_words_collection_widget.dart';
import 'package:dutch_app/pages/word_collections/nav_bars/word_list_nav_bar_widget.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordCollectionsListPage extends StatefulWidget {
  const WordCollectionsListPage({super.key});

  @override
  State<WordCollectionsListPage> createState() =>
      _WordCollectionsListPageState();
}

Widget customPadding() => const SizedBox(height: 10);

class _WordCollectionsListPageState extends State<WordCollectionsListPage> {
  bool isLoading = true;
  late WordCollectionsRepository collectionsRepository;
  late WordsStorageService wordsStorageService;
  List<SelectableWordCollectionModel> collections = [];
  List<Widget> collectionsAndWords = [];
  late WordCreatedNotifier notifier;
  final ScrollController scrollController = ScrollController();

  bool checkboxModeEnabled = false;

  Future<void> onAfterPopAsync(bool didPop, Object? result) async {
    if (checkboxModeEnabled) {
      _toggleCheckboxMode();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    notifier = context.read<WordCreatedNotifier>();
    notifier.addListener(_loadData);
    collectionsRepository = context.read<WordCollectionsRepository>();
    wordsStorageService = context.read<WordsStorageService>();
    _loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    notifier.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    double preservedScrollPosition = 0;
    if (scrollController.hasClients) {
      preservedScrollPosition = scrollController.offset;
    }
    setState(() {
      isLoading = true;
    });

    var dbCollections =
        await collectionsRepository.getCollectionsWithWordsAsync();

    var selectableCollections = dbCollections
        .map((col) => SelectableWordCollectionModel(col.id, col.name,
            col.words?.map((word) => SelectableWordModel(word)).toList()))
        .toList();

    setState(() {
      collections = selectableCollections;
      isLoading = false;
      collectionsAndWords = _buildWordsAndCollections(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (preservedScrollPosition != 0) {
        scrollController.jumpTo(preservedScrollPosition);
      }
    });
  }

  Future<void> _loadDataWithSnackBar(String message) async {
    var snackBar = ScaffoldMessenger.of(context);
    await _loadData();
    snackBar.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            print("Undo clicked!");
          },
        ),
      ),
    );
  }

  List<Widget> _buildWordsAndCollections(BuildContext context) {
    return collections
        .expand(
            (collection) => _buildSingleCollectionAndWords(context, collection))
        .toList();
  }

  void _unselectAllRows() {
    setState(() {
      for (var collection in collections) {
        collection.isSelected = false;
        for (var word in collection.words ?? []) {
          word.isSelected = false;
        }
      }
    });
  }

  void _selectCollection(SelectableWordCollectionModel collection) {
    if (!checkboxModeEnabled) return;
    setState(() {
      collection.isSelected = !collection.isSelected;
      if (collection.words != null) {
        for (var word in collection.words!) {
          word.isSelected = collection.isSelected;
        }
      }
    });
  }

  void _selectWord(SelectableWordModel word) {
    if (!checkboxModeEnabled) return;
    setState(() {
      word.isSelected = !word.isSelected;
    });
  }

  void _longPressCollection(SelectableWordCollectionModel collection) {
    if (checkboxModeEnabled) return;
    _toggleCheckboxMode();
    _selectCollection(collection);
  }

  void _longPressWord(SelectableWordModel word) {
    if (checkboxModeEnabled) return;
    _toggleCheckboxMode();
    _selectWord(word);
  }

  void _toggleCheckboxMode() {
    setState(() {
      checkboxModeEnabled = !checkboxModeEnabled;
      if (checkboxModeEnabled == false) {
        _unselectAllRows();
      }
    });
  }

  List<Widget> _buildSingleCollectionAndWords(
      BuildContext context, SelectableWordCollectionModel collection) {
    return [
      SelectableWordCollectionRow(
          collection: collection,
          onRowTap: _selectCollection,
          showCheckbox: checkboxModeEnabled,
          onLongRowPress: () {
            _longPressCollection(collection);
          }),
      ..._buildCollectionWordsWidgets(context, collection.words)
    ].toList();
  }

  List<Widget> _buildCollectionWordsWidgets(
      BuildContext context, List<SelectableWordModel>? words) {
    if (words == null) {
      return [];
    }
    return words
        .map(
          (word) => SelectableWord(
              word: word,
              showCheckbox: checkboxModeEnabled,
              onRowTap: _selectWord,
              onLongRowPress: () {
                _longPressWord(word);
              }),
        )
        .toList();
  }

  //todo move out
  Future<void> _onImportPressedAsync(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["json"]);
    if (result == null) {
      return;
    }

    ExportPackageV1 importPackage = await WordsIoJsonServiceV1()
        .importAsync(File(result.files.first.path!));

    await wordsStorageService.storeInDatabaseAsync(importPackage);
    final totalWords = importPackage.collections.fold<int>(
      0,
      (sum, collection) => sum + collection.words.length,
    );

    await _loadDataWithSnackBar(
        "Succesfully imported ${importPackage.collections.length} collection(s) with $totalWords words");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !checkboxModeEnabled,
        onPopInvokedWithResult: onAfterPopAsync,
        child: Scaffold(
            appBar: MyAppBar(title: Text(_appBarTitle())),
            body: _buildPage(context),
            bottomNavigationBar: _buildBottomNavBar(context)));
  }

  String _appBarTitle() {
    return checkboxModeEnabled
        ? "Select one or multiple items"
        : "Words and collections";
  }

  Widget _buildPage(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    collectionsAndWords = _buildWordsAndCollections(context);
    return Container(
      padding: ContainerStyles.containerPadding,
      child: ListView.builder(
        controller: scrollController,
        itemCount: collectionsAndWords.length,
        itemBuilder: (context, index) {
          return collectionsAndWords[index];
        },
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    if (checkboxModeEnabled) {
      return _buildCheckboxNavBar(context);
    }
    return _buildRegularNavBar(context);
  }

//todo move out?
  Widget _buildRegularNavBar(BuildContext context) {
    return WordListNavBar(
        context: context,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Word',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            label: 'Import',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add_check),
            label: 'Actions',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/newword');
              break;
            case 1:
              showAddCollectionDialog(
                  context: context,
                  callback: (() => _loadDataWithSnackBar(
                      "Succesfully created new collection")));
              break;
            case 2:
              _onImportPressedAsync(context);
              break;
            case 3:
              _toggleCheckboxMode();
              break;
          }
        });
  }

  Widget _buildCheckboxNavBar(BuildContext context) {
    return WordListNavBar(
        context: context,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_file_move),
            label: 'Move',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Copy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Export',
          ),
          BottomNavigationBarItem(
            icon: _buildMoreButton(context),
            label: 'More',
          ),
        ],
        onTap: (int index) {
          if (!_shouldEnableMultiselectButtons()) return;
          switch (index) {
            case 0:
              _toggleCheckboxMode();
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              showExportDataDialog(
                  context: context,
                  collections: _aggregateSelectedCollectionsAndWords(),
                  callback: ((filePath) => _loadDataWithSnackBar(
                      "Successfully exported words and collections to $filePath")) //todo counts of words and collections
                  );
              break;
            case 4:
              setState(() {
                if (menuController == null) {
                  return;
                }
                if (menuController!.isOpen) {
                  menuController!.close();
                } else {
                  menuController!.open();
                }
              });
              break;
          }
        });
  }

  MenuController? menuController;

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteWordDialog(
          onDeletePressed: (() => {print("delete clicked")}),
        );
      },
    );
  }

  bool _shouldEnableMultiselectButtons() {
    //more room for other conditions
    return _containsAtLeastOneSelectedItem();
  }

  bool _containsAtLeastOneSelectedItem() {
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].isSelected || collections[i].containsSelectedWords()) {
        return true;
      }
    }

    return false;
  }

  List<WordCollection> _aggregateSelectedCollectionsAndWords() {
    List<WordCollection> result = [];
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].isSelected || collections[i].containsSelectedWords()) {
        result.add(WordCollection(collections[i].id, collections[i].name,
            words: collections[i].getSelectedWords()));
      }
    }
    return result;
  }

  Widget _buildMoreButton(BuildContext context) {
    var actions = [
      MyPopupMenuItem(
        icon: Icons.delete,
        label: "Delete",
        onPressed: () => _showDeleteDialog(context),
      ),
    ];
    return MenuAnchor(
      alignmentOffset: const Offset(0, 8),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        menuController = controller;
        return const Icon(Icons.grid_view);
      },
      menuChildren: List<Widget>.generate(
        actions.length,
        (int index) => actions[index],
      ),
    );
  }
}
