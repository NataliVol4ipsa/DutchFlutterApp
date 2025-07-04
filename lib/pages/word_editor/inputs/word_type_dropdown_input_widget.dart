import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/Input_icons.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_type_dropdown.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class WordTypeDropdownInput extends StatelessWidget {
  final ValueNotifier<PartOfSpeech> valueNotifier;
  const WordTypeDropdownInput({super.key, required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PartOfSpeech>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return PaddedFormComponent(
          child: FormInput(
              inputLabel: "Word type",
              child: WordTypeDropdown(
                prefixIcon: FormInputIcon(InputIcons.wordType),
                initialValue: value,
                updateValueCallback: (newValue) =>
                    valueNotifier.value = newValue,
                dropdownArrowColor:
                    BaseStyles.getColorScheme(context).secondary,
                firstOptionGrey: true,
              )),
        );
      },
    );
  }
}
