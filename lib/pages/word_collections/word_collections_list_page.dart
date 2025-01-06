import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
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
  List<WordCollection> collections = [];

  @override
  void initState() {
    super.initState();
    collectionsRepository = context.read<WordCollectionsRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    var dbCollections =
        await collectionsRepository.getCollectionsWithWordsAsync();

    setState(() {
      collections = dbCollections;
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
      BuildContext context, WordCollection collection) {
    return [
      _buildSingleCollectionWidget(context, collection),
      ..._buildCollectionWordsWidgets(context, collection.words)
    ].toList();
  }

  Widget _buildSingleCollectionWidget(
      BuildContext context, WordCollection collection) {
    return Container(
        padding: ContainerStyles.smallContainerPadding,
        color: ContainerStyles.sectionColor(context),
        child: Text(collection.name));
  }

  List<Widget> _buildCollectionWordsWidgets(
      BuildContext context, List<Word>? words) {
    if (words == null) {
      return [];
    }
    return words.map((word) => _buildWordWidget(context, word)).toList();
  }

  Widget _buildWordWidget(BuildContext context, Word word) {
    return Container(
        padding: ContainerStyles.smallContainerPadding,
        child: Text("${word.dutchWord} - ${word.englishWord}"));
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
