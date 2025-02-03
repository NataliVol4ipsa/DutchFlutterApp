import 'dart:io';
import 'package:dutch_app/core/notifiers/word_created_notifier.dart';
import 'package:dutch_app/core/services/batch_word_operations_service.dart';
import 'package:dutch_app/core/services/practice_session_stateful_service.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';
import 'package:dutch_app/io/v1/words_io_json_service_v1.dart';
import 'package:dutch_app/pages/word_collections/dialogs/add_collection_dialog.dart';
import 'package:dutch_app/pages/word_collections/dialogs/delete_words_dialog.dart';
import 'package:dutch_app/pages/word_collections/dialogs/export_data_dialog.dart';
import 'package:dutch_app/pages/word_collections/dialogs/rename_collection_dialog.dart';
import 'package:dutch_app/pages/word_collections/popup_menu_item_widget.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection_model.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word_model.dart';
import 'package:dutch_app/pages/word_collections/selectable_word_widget.dart';
import 'package:dutch_app/pages/word_collections/selectable_words_collection_widget.dart';
import 'package:dutch_app/pages/word_collections/word_collection_list_manager.dart';
import 'package:dutch_app/pages/word_collections/dialogs/edit_word_dialog.dart';
import 'package:dutch_app/reusable_widgets/bottom_app_bar/more_actions_bottom_app_bar_widget.dart';
import 'package:dutch_app/reusable_widgets/bottom_app_bar/my_bottom_app_bar_item_widget.dart';
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
  late WordCollectionListManager dataManager;
  bool isLoading = true;
  List<Widget> collectionsAndWords = [];
  late WordCreatedNotifier notifier;
  final ScrollController scrollController = ScrollController();
  late BatchWordOperationsService wordsStorageService;

  bool checkboxModeEnabled = false;

  @override
  void initState() {
    super.initState();
    notifier = context.read<WordCreatedNotifier>();
    notifier.addListener(_loadDataAsync);
    dataManager = WordCollectionListManager(context);
    wordsStorageService = context.read<BatchWordOperationsService>();
    _loadDataAsync();
  }

  @override
  void dispose() {
    scrollController.dispose();
    notifier.removeListener(_loadDataAsync);
    super.dispose();
  }

  Future<void> onAfterPopAsync(bool didPop, Object? result) async {
    if (checkboxModeEnabled) {
      _toggleCheckboxMode();
      return;
    }
  }

  Future<void> _loadDataAsync() async {
    double preservedScrollPosition = 0;
    if (scrollController.hasClients) {
      preservedScrollPosition = scrollController.offset;
    }
    setState(() {
      isLoading = true;
    });
    await dataManager.loadCollectionsAsync();
    setState(() {
      collectionsAndWords = _buildWordsAndCollections(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (preservedScrollPosition != 0) {
        scrollController.jumpTo(preservedScrollPosition);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadDataWithSnackBar(String message) async {
    var snackBar = ScaffoldMessenger.of(context);
    if (checkboxModeEnabled) {
      _toggleCheckboxMode();
    }
    await _loadDataAsync();
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
    return dataManager.collections
        .expand((collection) =>
            _buildSingleCollectionAndItsWords(context, collection))
        .toList();
  }

  void _toggleIsSelectedCollection(SelectableWordCollectionModel collection) {
    setState(() {
      collection.toggleIsSelectedCollectionAndWords();
    });
  }

  void _onCollectionRowTap(SelectableWordCollectionModel collection) {
    if (!checkboxModeEnabled) {
      _showUpdateCollectionDialog(collection);
    } else {
      _toggleIsSelectedCollection(collection);
    }
  }

  void _selectWord(SelectableWordModel word) {
    if (!checkboxModeEnabled) {
      _showEditWordDialog(context, word);
      return;
    }
    ;
    setState(() {
      word.toggleIsSelected();
    });
  }

  void _longPressCollection(SelectableWordCollectionModel collection) {
    if (checkboxModeEnabled) return;
    _toggleCheckboxMode();
    _toggleIsSelectedCollection(collection);
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
        dataManager.unselectWordsAndCollections();
      }
    });
  }

  void _showUpdateCollectionDialog(SelectableWordCollectionModel collection) {
    showRenameCollectionDialog(
      context: context,
      collectionId: collection.id,
      initialName: collection.name,
      callback: ((newName) async {
        await _loadDataWithSnackBar(
            "Succesfully renamed collection '${collection.name}' to '$newName'");
      }),
    );
  }

  void _showDeleteWordsDialog(BuildContext context) {
    var wordIds = dataManager.getAllSelectedWordIds();
    showDeleteWordsDialog(
      context: context,
      collectionIds: [],
      wordIds: wordIds,
      callback: (() => _loadDataWithSnackBar(
          "Succesfully deleted '${wordIds.length}' words.")),
    );
  }

  Future<void> _showEditWordDialog(
      BuildContext context, SelectableWordModel word) async {
    await EditWordDialog.show(
      context: context,
      word: word.value,
    );

    //todo track state when there were are no changes.
    await _loadDataWithSnackBar("Successfully updated word.");
  }

  List<Widget> _buildSingleCollectionAndItsWords(
      BuildContext context, SelectableWordCollectionModel collection) {
    return [
      SelectableWordCollectionRow(
          collection: collection,
          onRowTap: _onCollectionRowTap,
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
              extraLeftPadding: ContainerStyles.defaultPadding,
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

  String _multiselectAppBarTitle() {
    int selectedWordsCount = dataManager.calculateSelectedWords();
    if (selectedWordsCount == 0) {
      return "Select one or multiple items";
    }
    if (selectedWordsCount == 1) return "Selected 1 word";
    return "Selected $selectedWordsCount words";
  }

  String _appBarTitle() {
    return checkboxModeEnabled
        ? _multiselectAppBarTitle()
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

  Widget _buildRegularNavBar(BuildContext context) {
    return BottomAppBar(
        height: 68,
        color: ContainerStyles.bottomNavBarColor(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyBottomAppBarItem(
                icon: Icons.add,
                disabledIcon: Icons.add_outlined,
                label: 'Word',
                onTap: (() => {Navigator.pushNamed(context, '/newword')})),
            MyBottomAppBarItem(
                icon: Icons.add,
                disabledIcon: Icons.add_outlined,
                label: 'Collection',
                onTap: (() => {
                      showAddCollectionDialog(
                          context: context,
                          callback: (() => _loadDataWithSnackBar(
                              "Succesfully created new collection")))
                    })),
            MyBottomAppBarItem(
                icon: Icons.file_download,
                disabledIcon: Icons.file_download_outlined,
                label: 'Import',
                onTap: (() => {_onImportPressedAsync(context)})),
            MyBottomAppBarItem(
                icon: Icons.library_add_check,
                disabledIcon: Icons.library_add_check_outlined,
                label: 'Actions',
                onTap: (() => {_toggleCheckboxMode()})),
          ],
        ));
  }

  Widget _buildCheckboxNavBar(BuildContext context) {
    return BottomAppBar(
        height: 68,
        color: ContainerStyles.bottomNavBarColor(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyBottomAppBarItem(
                icon: Icons.school,
                disabledIcon: Icons.school_outlined,
                isEnabled: _shouldEnableMultiselectButtons(),
                label: 'Practice',
                onTap: (() => {_handleOnPracticeActionTap(context)})),
            MyBottomAppBarItem(
                icon: Icons.drive_file_move,
                disabledIcon: Icons.drive_file_move_outlined,
                isEnabled: _shouldEnableMultiselectButtons(),
                label: 'Move',
                onTap: (() => {print('Tapped Move!')})),
            MyBottomAppBarItem(
                icon: Icons.file_copy,
                disabledIcon: Icons.file_copy_outlined,
                isEnabled: _shouldEnableMultiselectButtons(),
                label: 'Copy',
                onTap: (() => {print('Tapped Copy!')})),
            MyBottomAppBarItem(
                icon: Icons.upload_file_rounded,
                disabledIcon: Icons.upload_file_outlined,
                isEnabled: _shouldEnableMultiselectButtons(),
                label: 'Export',
                onTap: (() => {_handleOnExportActionTap(context)})),
            _buildMoreButton(context),
          ],
        ));
  }

  void _handleOnPracticeActionTap(BuildContext context) {
    if (!dataManager.containsAtLeastOneSelectedWord()) return;
    var service = context.read<PracticeSessionStatefulService>();
    service.initializeWords(dataManager.getAllSelectedWords());
    Navigator.pushNamed(
      context,
      '/exerciseselector',
    );
  }

  void _handleOnExportActionTap(BuildContext context) {
    if (!dataManager.containsAtLeastOneSelectedItem()) return;
    showExportDataDialog(
        context: context,
        collections: dataManager.getCollectionsWithAtLeastOneSelectedWord(),
        callback: ((filePath) => _loadDataWithSnackBar(
            "Successfully exported words and collections to $filePath")) //todo counts of words and collections
        );
  }

  //todo
  bool _shouldEnableMultiselectButtons() {
    //more room for other conditions
    return dataManager.containsAtLeastOneSelectedItem();
  }

  void Function()? createOnDeletePressedFunc(BuildContext context) {
    return dataManager.containsAtLeastOneSelectedWord()
        ? () => {_showDeleteWordsDialog(context)}
        : null;
  }

  Widget _buildMoreButton(BuildContext context) {
    return MoreActionsBottomAppBar(
        actions: _buildMoreActions(context),
        verticalOffset: 13,
        isEnabled: _shouldEnableMultiselectButtons());
  }

  List<Widget> _buildMoreActions(BuildContext context) {
    return [
      MyPopupMenuItem(
        icon: Icons.delete,
        label: "Delete Words",
        onPressed: createOnDeletePressedFunc(context),
      ),
    ];
  }
}
