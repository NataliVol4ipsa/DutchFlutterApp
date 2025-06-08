import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:flutter/material.dart';

class PresentTenseJullieInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const PresentTenseJullieInput(
      {super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Tegenwoordige tijd - Jullie",
        hintText: "Tegenwoordige tijd - Jullie",
        isRequired: false,
        prefixIcon: FormInputIcon(InputIcons.presentTense),
      ),
    );
  }
}
