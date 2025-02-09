import 'package:dutch_app/pages/word_editor_2/online_search/online_word_search_modal.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/pages/word_editor_2/validation_functions.dart';
import 'package:flutter/material.dart';

class DutchWordInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const DutchWordInput({super.key, required this.textEditingController});

  Widget _buildSearchSuffixIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        if (textEditingController.text.trim() == "") return;
        OnlineWordSearchModal.show(context, textEditingController.text);
      },
      child: Icon(Icons.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Dutch",
        hintText: "Dutch word",
        isRequired: true,
        valueValidator: nonEmptyString,
        invalidInputErrorMessage: "Dutch word is required",
        suffixIcon: _buildSearchSuffixIcon(context),
      ),
    );
  }
}
