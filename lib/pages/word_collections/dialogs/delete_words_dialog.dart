import 'package:dutch_app/domain/services/batch_word_operations_service.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDeleteWordsDialog(
    {required BuildContext context,
    required List<int> collectionIds,
    required List<int> wordIds,
    required Future<void> Function() callback,
    String? additionalText}) {
  var service = context.read<BatchWordOperationsService>();
  //todo create custom just like text input modal
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete following item(s)?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (additionalText != null)
                Text(
                  additionalText,
                  style: TextStyles.modalDescriptionTextStyle,
                ),
              Text(
                'This action is permanent.',
                style: TextStyles.modalDescriptionTextStyle,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                ),
                const SizedBox(
                  height: 30,
                  child: VerticalDivider(thickness: 1, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    _deleteDataAsync(collectionIds, wordIds, service, callback);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'DELETE',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
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
