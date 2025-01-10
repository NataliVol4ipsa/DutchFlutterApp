import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/reusable_widgets/text_input_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddCollectionDialog(
    {required BuildContext context,
    required Future<void> Function() callback}) {
  var repository = context.read<WordCollectionsRepository>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TextInputModal(
        title: 'Creating new word collection',
        inputLabel: "Choose collection name",
        confirmText: 'CREATE',
        onConfirmPressed: ((context, input) =>
            _createCollectionAsync(context, input, repository, callback)),
      );
    },
  );
}

Future<void> _createCollectionAsync(
    BuildContext context,
    String collectionName,
    WordCollectionsRepository repository,
    Future<void> Function() callback) async {
  await repository.addAsync(WordCollection(null, collectionName));
  await callback();
}
