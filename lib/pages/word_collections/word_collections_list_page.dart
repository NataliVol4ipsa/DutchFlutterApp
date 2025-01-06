import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/reusable_widgets/text_input_modal.dart';
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
  List<SelectableWordCollection> collections = [];

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
        .map((col) => SelectableWordCollection(col.id, col.name,
            col.words?.map((word) => SelectableWord(word)).toList()))
        .toList();

    setState(() {
      collections = selectableCollections;
      isLoading = false;
    });
  }

  void onAddCollectionButtonPressed(BuildContext context) {
    showAddCollectionDialog(context);
  }

  void showAddCollectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextInputModal(
          title: 'Creating new word collection',
          inputLabel: "Choose collection name",
          confirmText: 'CREATE',
          onConfirmPressed: createCollectionAsync,
        );
      },
    );
  }

  Future<void> createCollectionAsync(
      BuildContext context, String collectionName) async {
    await collectionsRepository.addAsync(WordCollection(null, collectionName));
    await _loadData();
  }

  List<Widget> _buildWordsAndCollections(BuildContext context) {
    return collections
        .expand(
            (collection) => _buildSingleCollectionAndWords(context, collection))
        .toList();
  }

  List<Widget> _buildSingleCollectionAndWords(
      BuildContext context, SelectableWordCollection collection) {
    return [
      _buildSingleCollectionWidget(context, collection),
      ..._buildCollectionWordsWidgets(context, collection.words)
    ].toList();
  }

  Widget _buildSingleCollectionWidget(
      BuildContext context, SelectableWordCollection collection) {
    return GestureDetector(
      onTap: () => {_selectCollection(collection)},
      child: Container(
          color: collection.isSelected
              ? ContainerStyles.selectedPrimaryColor(context)
              : ContainerStyles.sectionColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(collection.name),
              SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: Checkbox(
                      value: collection.isSelected,
                      onChanged: (value) => {_selectCollection(collection)})),
            ],
          )),
    );
  }

  void _selectCollection(SelectableWordCollection collection) {
    setState(() {
      collection.isSelected = !collection.isSelected;
      if (collection.words != null) {
        for (var word in collection.words!) {
          word.isSelected = collection.isSelected;
        }
      }
    });
  }

  List<Widget> _buildCollectionWordsWidgets(
      BuildContext context, List<SelectableWord>? words) {
    if (words == null) {
      return [];
    }
    return words.map((word) => _buildWordWidget(context, word)).toList();
  }

  Widget _buildWordWidget(BuildContext context, SelectableWord selectableWord) {
    var word = selectableWord.word;
    var dutchWord = word.deHetType != DeHetType.none
        ? "${word.deHetType.label} ${word.dutchWord}"
        : word.dutchWord;
    return GestureDetector(
      onTap: () => {_selectWord(selectableWord)},
      child: Container(
          color: selectableWord.isSelected
              ? ContainerStyles.selectedSecondaryColor(context)
              : ContainerStyles.backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$dutchWord - ${word.englishWord}",
                style: TextStyle(
                    color: selectableWord.isSelected
                        ? ContainerStyles.selectedSecondaryTextColor(context)
                        : ContainerStyles.backgroundTextColor(context)),
              ),
              SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: Checkbox(
                      value: selectableWord.isSelected,
                      onChanged: (value) => {_selectWord(selectableWord)})),
            ],
          )),
    );
  }

  void _selectWord(SelectableWord word) {
    setState(() {
      word.isSelected = !word.isSelected;
    });
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
        floatingActionButton: Padding(
          padding:
              const EdgeInsets.only(bottom: ContainerStyles.defaultPadding),
          child: FloatingActionButton(
            onPressed: () => {onAddCollectionButtonPressed(context)},
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }
}
