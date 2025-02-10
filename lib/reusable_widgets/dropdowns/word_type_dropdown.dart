import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/reusable_widgets/dropdowns/generic_dropdown_menu.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';

class WordTypeDropdown extends StatefulWidget {
  final Function updateValueCallback;
  final WordType? initialValue;
  final Widget? prefixIcon;
  final Color? dropdownArrowColor;
  final bool firstOptionGrey;
  const WordTypeDropdown(
      {super.key,
      required this.updateValueCallback,
      this.initialValue,
      this.prefixIcon,
      this.dropdownArrowColor,
      this.firstOptionGrey = false});

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

  static Color? _firstOptionGrey(WordType wordType, BuildContext context) {
    return wordType == WordType.unspecified
        ? TextStyles.dropdownGreyTextColor(context)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return GenericDropdownMenu(
      prefixIcon: widget.prefixIcon,
      initialValue: widget.initialValue,
      onValueChanged: updateSelectedWordType,
      dropdownValues: wordTypeDropdownValues,
      displayStringFunc: (wt) => wt.capitalLabel,
      dropdownArrowColor: widget.dropdownArrowColor,
      dropdownOptionColorGenerator: widget.firstOptionGrey
          ? (WordType wordType) => _firstOptionGrey(wordType, context)
          : null,
    );
  }
}
