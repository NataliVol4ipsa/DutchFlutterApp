import 'package:dutch_app/pages/word_editor/inputs/form_text_input_widget.dart';
import 'package:flutter/material.dart';

class TextInputModal extends StatefulWidget {
  final Future<void> Function(BuildContext context, String input)
      onConfirmPressed;
  final String title;
  final String? inputLabel;
  final String? confirmText;
  final String? initialValue;
  final bool Function(String?)? validateInput;
  final String? invalidInputErrorMessage;
  final Widget? prefixIcon;

  const TextInputModal({
    super.key,
    required this.title,
    required this.onConfirmPressed,
    this.inputLabel,
    this.confirmText,
    this.initialValue,
    this.validateInput,
    this.invalidInputErrorMessage,
    this.prefixIcon,
  });

  @override
  State<TextInputModal> createState() => _TextInputModalState();
}

class _TextInputModalState extends State<TextInputModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputController.text = widget.initialValue ?? "";
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
            FormTextInput(
              textInputController: inputController,
              inputLabel: widget.inputLabel ?? "Please enter text value:",
              isRequired: true,
              valueValidator: widget.validateInput,
              invalidInputErrorMessage:
                  widget.invalidInputErrorMessage ?? "Value is not correct.",
              prefixIcon: widget.prefixIcon,
            ),
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
              onPressed: _onConfirmPressed,
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

  void _onConfirmPressed() {
    if (!_formKey.currentState!.validate()) return;

    widget.onConfirmPressed(context, inputController.text);
    Navigator.of(context).pop();
  }
}
