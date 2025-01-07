import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';
import 'package:dutch_app/pages/word_collections/selectable_word_widget.dart';
import 'package:dutch_app/pages/word_collections/selectable_words_collection_widget.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
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
  List<SelectableWordCollectionModel> collections = [];

  bool checkboxModeEnabled = false;

  @override
  void initState() {
    super.initState();
    collectionsRepository = context.read<WordCollectionsRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    var dbCollections =
        await collectionsRepository.getCollectionsWithWordsAsync();

    var selectableCollections = dbCollections
        .map((col) => SelectableWordCollectionModel(col.id, col.name,
            col.words?.map((word) => SelectableWordModel(word)).toList()))
        .toList();

    setState(() {
      collections = selectableCollections;
      isLoading = false;
    });
  }

  List<Widget> _buildWordsAndCollections(BuildContext context) {
    return collections
        .expand(
            (collection) => _buildSingleCollectionAndWords(context, collection))
        .toList();
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
    if (checkboxModeEnabled) return;
    setState(() {
      checkboxModeEnabled = true;
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Widget> collectionsAndWords = _buildWordsAndCollections(context);

    return Scaffold(
      appBar: const MyAppBar(title: Text('Word collections')),
      body: Container(
        padding: ContainerStyles.containerPadding,
        child: ListView.builder(
          itemCount: collectionsAndWords.length,
          itemBuilder: (context, index) {
            return collectionsAndWords[index];
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    if (checkboxModeEnabled) {
      return _buildCheckboxNavBar(context);
    }
    return _buildRegularNavBar(context);
  }

//todo move out?
  BottomNavigationBar _buildRegularNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ContainerStyles.bottomNavBarColor(context),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Word',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
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
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            _toggleCheckboxMode();
            break;
        }
      },
    );
  }

  BottomNavigationBar _buildCheckboxNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: ContainerStyles.bottomNavBarColor(context),
      selectedItemColor: ContainerStyles.bottomNavBarTextColor(context),
      selectedLabelStyle:
          TextStyle(color: ContainerStyles.bottomNavBarTextColor(context)),
      unselectedItemColor: ContainerStyles.bottomNavBarTextColor(context),
      unselectedLabelStyle:
          TextStyle(color: ContainerStyles.bottomNavBarTextColor(context)),
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
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
          icon: Icon(Icons.grid_view),
          label: 'More',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            _toggleCheckboxMode();
            break;
        }
      },
    );
  }

  // void onAddCollectionButtonPressed(BuildContext context) {
  //   showAddCollectionDialog(context);
  // }

  // void showAddCollectionDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return TextInputModal(
  //         title: 'Creating new word collection',
  //         inputLabel: "Choose collection name",
  //         confirmText: 'CREATE',
  //         onConfirmPressed: createCollectionAsync,
  //       );
  //     },
  //   );
  // }

  // Future<void> createCollectionAsync(
  //     BuildContext context, String collectionName) async {
  //   await collectionsRepository.addAsync(WordCollection(null, collectionName));
  //   await _loadData();
  // }
}
