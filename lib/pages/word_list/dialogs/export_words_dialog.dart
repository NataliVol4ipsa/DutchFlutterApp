import 'package:first_project/reusable_widgets/input_label.dart';
import 'package:flutter/material.dart';

class ExportWordsDialog extends StatefulWidget {
  final Function onExportPressed;

  const ExportWordsDialog({
    super.key,
    required this.onExportPressed,
  });

  @override
  State<ExportWordsDialog> createState() => _ExportWordsDialogState();
}

class _ExportWordsDialogState extends State<ExportWordsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fileNameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exporting word list:'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const InputLabel(
                  "Choose file name",
                )),
            TextFormField(
              controller: fileNameInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
            )
          ],
        ),
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
                widget.onExportPressed(context, fileNameInputController.text);
                Navigator.of(context).pop();
              },
              child: const Text(
                'EXPORT',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
