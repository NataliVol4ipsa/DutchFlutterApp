import 'package:dutch_app/domain/services/batch_word_operations_service.dart';
import 'package:dutch_app/reusable_widgets/modals/confirmation_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDeleteWordsDialog(
    {required BuildContext context,
    required List<int> collectionIds,
    required List<int> wordIds,
    required Future<void> Function() callback,
    String? additionalText}) {
  var service = context.read<BatchWordOperationsService>();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationModal(
          title: 'Delete following item(s)?',
          description: 'This action is permanent.',
          confirmButtonText: 'DELETE',
          onConfirmPressed: (context) async {
            await _deleteDataAsync(collectionIds, wordIds, service, callback);
          },
        );
      });
}

Future<void> _deleteDataAsync(
    List<int> collectionIds,
    List<int> wordIds,
    BatchWordOperationsService service,
    Future<void> Function() callback) async {
  await service.deleteAsync(wordIds: wordIds, collectionIds: collectionIds);
  await callback();
}
