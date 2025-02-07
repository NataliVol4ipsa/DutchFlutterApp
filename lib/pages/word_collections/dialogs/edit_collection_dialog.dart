import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/services/collection_permission_service.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/reusable_widgets/text_input_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showEditCollectionDialog(
    {required BuildContext context,
    required int collectionId,
    required String initialName,
    required Future<void> Function(String) callback}) {
  var repository = context.read<WordCollectionsRepository>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TextInputModal(
        title: 'Edit collection',
        inputLabel: "Choose collection name",
        confirmText: 'UPDATE',
        initialValue: initialName,
        onConfirmPressed: ((context, input) =>
            _updateCollectionAsync(collectionId, input, repository, callback)),
        validateInput: CollectionPermissionService.canRenameCollectionIntoName,
        prefixIcon: Icon(Icons.collections_bookmark_outlined),
      );
    },
  );
}

Future<void> _updateCollectionAsync(
    int collectionId,
    String newName,
    WordCollectionsRepository repository,
    Future<void> Function(String) callback) async {
  await repository.updateAsync(WordCollection(collectionId, newName));
  await callback(newName);
}
