import 'package:dutch_app/core/functions/capitalize_enum.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/generic_dropdown_menu.dart';
import 'package:flutter/cupertino.dart';

class WordTypeDropdown extends StatefulWidget {
  final Function updateValueCallback;
  final WordType? initialValue;
  const WordTypeDropdown(
      {super.key, required this.updateValueCallback, this.initialValue});

  @override
  State<WordTypeDropdown> createState() => _WordTypeDropdownState();
}

class _WordTypeDropdownState extends State<WordTypeDropdown> {
  List<WordType> wordTypeDropdownValues = WordType.values.toList();
  WordType? selectedWordType;

  void updateSelectedWordType(WordType? value) {
    setState(() {
      selectedWordType = value;
    });
    widget.updateValueCallback(value);
  }

  @override
  Widget build(BuildContext context) {
    return GenericDropdownMenu(
        initialValue: widget.initialValue,
        onValueChanged: updateSelectedWordType,
        dropdownValues: wordTypeDropdownValues,
        displayStringFunc: capitalizeEnum);
  }
}
