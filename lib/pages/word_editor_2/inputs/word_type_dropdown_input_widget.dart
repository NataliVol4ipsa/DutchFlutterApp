import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_type_dropdown.dart';
import 'package:flutter/material.dart';

class WordTypeDropdownInput extends StatelessWidget {
  final ValueNotifier<WordType> valueNotifier;
  const WordTypeDropdownInput({super.key, required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WordType>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return PaddedFormComponent(
          child: FormInput(
              inputLabel: "Word type",
              child: WordTypeDropdown(
                initialValue: value,
                updateValueCallback: (newValue) =>
                    valueNotifier.value = newValue,
              )),
        );
      },
    );
  }
}
