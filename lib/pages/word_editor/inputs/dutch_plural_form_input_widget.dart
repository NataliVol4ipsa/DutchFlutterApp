import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:flutter/material.dart';

class DutchPluralFormInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const DutchPluralFormInput({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Dutch plural form",
        hintText: "Dutch plural form",
        isRequired: false,
        prefixIcon: FormInputIcon(Icons.library_books),
      ),
    );
  }
}
