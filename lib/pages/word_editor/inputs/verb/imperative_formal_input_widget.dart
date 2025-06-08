import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:flutter/material.dart';

class ImperativeFormalInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const ImperativeFormalInput({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Gebiedende wijs - Formeel",
        hintText: "Gebiedende wijs - Formeel",
        isRequired: false,
        prefixIcon: FormInputIcon(InputIcons.imperative),
      ),
    );
  }
}
