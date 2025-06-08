import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/Input_icons.dart';
import 'package:flutter/material.dart';

class DutchDiminutiveFormInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const DutchDiminutiveFormInput(
      {super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Diminutive",
        hintText: "Diminutive",
        isRequired: false,
        prefixIcon: FormInputIcon(InputIcons.dutchDiminutive),
      ),
    );
  }
}
