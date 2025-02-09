import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_collection_dropdown.dart';
import 'package:flutter/material.dart';

class CollectionDropdownInput extends StatelessWidget {
  final ValueNotifier<WordCollection> valueNotifier;
  const CollectionDropdownInput({super.key, required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WordCollection>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return PaddedFormComponent(
          child: FormInput(
              inputLabel: "Word type",
              child: WordCollectionDropdown(
                initialValue: value,
                updateValueCallback: (newValue) =>
                    valueNotifier.value = newValue,
              )),
        );
      },
    );
  }
}
