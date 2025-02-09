import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/models/toggle_button_item.dart';
import 'package:dutch_app/reusable_widgets/optional_toggle_buttons.dart';
import 'package:flutter/material.dart';

class DeHetOptionalToggleInput extends StatelessWidget {
  final ValueNotifier<DeHetType> valueNotifier;
  const DeHetOptionalToggleInput({super.key, required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DeHetType>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return PaddedFormComponent(
          child: FormInput(
            inputLabel: "De/Het type",
            child: OptionalToggleButtons<DeHetType?>(
              items: [
                ToggleButtonItem(label: 'De', value: DeHetType.de),
                ToggleButtonItem(label: 'Het', value: DeHetType.het),
              ],
              onChanged: (newValue) =>
                  valueNotifier.value = newValue ?? DeHetType.none,
              selectedValue: value,
            ),
          ),
        );
      },
    );
  }
}
