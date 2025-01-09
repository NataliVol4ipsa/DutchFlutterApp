import 'package:dutch_app/pages/word_editor/inputs/form_input_widget.dart';
import 'package:flutter/material.dart';

class TextFormInput extends StatefulWidget {
  final TextEditingController textInputController;
  final String? inputLabel;
  final bool isRequired;
  final String? hintText;
  final bool Function(String?)? valueValidator;
  final String? invalidInputErrorMessage;
  const TextFormInput(
      {super.key,
      required this.textInputController,
      this.hintText,
      this.inputLabel,
      this.isRequired = false,
      this.valueValidator,
      this.invalidInputErrorMessage});

  @override
  State<TextFormInput> createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {
  @override
  Widget build(BuildContext context) {
    return FormInput(
      inputLabel: widget.inputLabel,
      isRequired: widget.isRequired,
      child: TextFormField(
        controller: widget.textInputController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.valueValidator != null && !widget.valueValidator!(value)) {
            return widget.invalidInputErrorMessage;
          }
          return null;
        },
      ),
    );
  }
}
