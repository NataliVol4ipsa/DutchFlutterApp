import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_text_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:flutter/material.dart';

class PresentParticipleInflectedInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const PresentParticipleInflectedInput(
      {super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PaddedFormComponent(
      child: FormTextInput(
        textInputController: textEditingController,
        inputLabel: "Tegenwoordig deelwoord - Vervoegd",
        hintText: "Tegenwoordig deelwoord - Vervoegd",
        isRequired: false,
        prefixIcon: FormInputIcon(InputIcons.presentParticiple),
      ),
    );
  }
}
