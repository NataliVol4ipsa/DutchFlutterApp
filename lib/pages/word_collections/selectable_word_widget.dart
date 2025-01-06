import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWord extends StatefulWidget {
  final SelectableWordModel word;
  final bool showCheckbox;
  final void Function() onLongRowPress;
  const SelectableWord(
      {super.key,
      required this.word,
      required this.onLongRowPress,
      required this.showCheckbox});

  @override
  State<SelectableWord> createState() => _SelectableWordState();
}

class _SelectableWordState extends State<SelectableWord> {
  void _selectWord(SelectableWordModel word) {
    setState(() {
      word.isSelected = !word.isSelected;
    });
  }

  Color _backgroundColor(BuildContext context) {
    return widget.word.isSelected
        ? ContainerStyles.selectedSecondaryColor(context)
        : ContainerStyles.backgroundColor(context);
  }

  Color _textColor(BuildContext context) {
    return widget.word.isSelected
        ? ContainerStyles.selectedSecondaryTextColor(context)
        : ContainerStyles.backgroundTextColor(context);
  }

  @override
  Widget build(BuildContext context) {
    var word = widget.word.word;
    var dutchWord = word.deHetType != DeHetType.none
        ? "${word.deHetType.label} ${word.dutchWord}"
        : word.dutchWord;
    return GestureDetector(
      onTap: () => {_selectWord(widget.word)},
      onLongPress: widget.onLongRowPress,
      child: Container(
          color: _backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "$dutchWord - ${word.englishWord}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _textColor(context)),
                ),
              ),
              if (widget.showCheckbox)
                MyCheckbox(
                    value: widget.word.isSelected,
                    onChanged: (value) => {_selectWord(widget.word)}),
            ],
          )),
    );
  }
}
