import 'package:first_project/core/models/word_collection.dart';
import 'package:first_project/local_db/repositories/word_collections_repository.dart';
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
  late WordCollectionsRepository collectionsRepository;
  List<WordCollection> collections = [];

  @override
  void initState() {
    super.initState();
    collectionsRepository = context.read<WordCollectionsRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    var dbCollections = await collectionsRepository.getAsync();

    setState(() {
      collections = dbCollections;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Word collections')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  WordCollection collection = collections[index];

                  return Column(
                    children: [
                      ListTile(
                        title: Text(collection.name),
                        tileColor: colorScheme.primary.withOpacity(0.3),
                        textColor: colorScheme.onPrimary,
                      ),
                      customPadding(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
