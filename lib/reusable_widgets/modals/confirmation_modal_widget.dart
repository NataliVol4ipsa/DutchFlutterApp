import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ConfirmationModal extends StatefulWidget {
  final String title;
  final String? description;
  final String? confirmButtonText;
  final Future<void> Function(BuildContext context) onConfirmPressed;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.onConfirmPressed,
    this.description,
    this.confirmButtonText,
  });

  @override
  State<ConfirmationModal> createState() => _ConfirmationModalState();
}

class _ConfirmationModalState extends State<ConfirmationModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            if (widget.description != null)
              Text(
                widget.description!,
                style: TextStyles.modalDescriptionTextStyle,
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
                widget.confirmButtonText ?? 'OK',
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

    widget.onConfirmPressed(context);
    Navigator.of(context).pop();
  }
}
