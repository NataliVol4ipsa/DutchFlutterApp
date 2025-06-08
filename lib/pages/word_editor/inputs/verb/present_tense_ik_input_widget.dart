import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:flutter/material.dart';

class PresentTenseIkInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const PresentTenseIkInput({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Tegenwoordige tijd - Ik",
        hintText: "Tegenwoordige tijd - Ik",
        isRequired: false,
        prefixIcon: FormInputIcon(InputIcons.presentTense),
      ),
    );
  }
}
