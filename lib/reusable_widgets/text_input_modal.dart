import 'package:first_project/reusable_widgets/input_label.dart';
import 'package:flutter/material.dart';

class TextInputModal extends StatefulWidget {
  final Future<void> Function(BuildContext context, String fileName)
      onConfirmPressed;
  final String title;
  final String? inputLabel;
  final String? confirmText;
  final String? initialValue;

  const TextInputModal({
    super.key,
    required this.title,
    required this.onConfirmPressed,
    this.inputLabel,
    this.confirmText,
    this.initialValue,
  });

  @override
  State<TextInputModal> createState() => _TextInputModalState();
}

class _TextInputModalState extends State<TextInputModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fileNameInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fileNameInputController.text = widget.initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: InputLabel(
                  widget.inputLabel ?? "Please enter text value:",
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
                widget.onConfirmPressed(context, fileNameInputController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                widget.confirmText ?? 'OK',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
