import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/padded_form_component_widget.dart';
import 'package:dutch_app/reusable_widgets/Input_icons.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/word_collection_dropdown.dart';
import 'package:dutch_app/styles/base_styles.dart';
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
              inputLabel: "Collection",
              child: WordCollectionDropdown(
                prefixIcon: FormInputIcon(InputIcons.collection),
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
