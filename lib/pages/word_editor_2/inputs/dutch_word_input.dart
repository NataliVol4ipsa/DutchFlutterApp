import 'package:dutch_app/pages/word_editor_2/online_search/online_word_search_modal.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/pages/word_editor_2/validation_functions.dart';
import 'package:flutter/material.dart';

class DutchWordInput extends StatelessWidget {
  final TextEditingController dutchWordTextInputController =
      TextEditingController();

  DutchWordInput({super.key, String? initialValue}) {
    if (initialValue != null) {
      dutchWordTextInputController.text = initialValue;
    }
  }

  Widget _buildSearchSuffixIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dutchWordTextInputController.text.trim() == "") return;
        OnlineWordSearchModal.show(context, dutchWordTextInputController.text);
      },
      child: Icon(Icons.search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: dutchWordTextInputController,
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
