import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/core/io/v1/words_io_json_service_v1.dart';
import 'package:dutch_app/reusable_widgets/text_input_modal.dart';
import 'package:flutter/material.dart';

void showExportDataDialog(
    {required BuildContext context,
    required List<WordCollection> collections,
    required void Function(String) callback}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TextInputModal(
        title: 'Exporting word list',
        inputLabel: "Choose file name",
        confirmText: 'EXPORT',
        onConfirmPressed: ((context, input) =>
            _exportDataAsync(context, input, collections, callback)),
      );
    },
  );
}

Future<void> _exportDataAsync(BuildContext context, String fileName,
    List<WordCollection> collections, void Function(String) callback) async {
  String path = await WordsIoJsonServiceV1().exportAsync(collections, fileName);
  callback(path);
}
