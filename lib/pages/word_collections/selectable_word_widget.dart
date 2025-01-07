import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWord extends StatelessWidget {
  final SelectableWordModel word;
  final bool showCheckbox;
  final Function(SelectableWordModel) onRowTap;
  final void Function() onLongRowPress;
  const SelectableWord(
      {super.key,
      required this.word,
      required this.onRowTap,
      required this.onLongRowPress,
      required this.showCheckbox});

  Color _backgroundColor(BuildContext context) {
    return word.isSelected
        ? ContainerStyles.selectedSecondaryColor(context)
        : ContainerStyles.backgroundColor(context);
  }

  Color _textColor(BuildContext context) {
    return word.isSelected
        ? ContainerStyles.selectedSecondaryTextColor(context)
        : ContainerStyles.backgroundTextColor(context);
  }

  @override
  Widget build(BuildContext context) {
    var wordValue = word.word;
    var dutchWord = wordValue.deHetType != DeHetType.none
        ? "${wordValue.deHetType.label} ${wordValue.dutchWord}"
        : wordValue.dutchWord;
    return GestureDetector(
      onTap: () => {onRowTap(word)},
      onLongPress: onLongRowPress,
      child: Container(
          color: _backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "$dutchWord - ${wordValue.englishWord}",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _textColor(context)),
                ),
              ),
              if (showCheckbox)
                MyCheckbox(
                    value: word.isSelected,
                    onChanged: (value) => {onRowTap(word)}),
            ],
          )),
    );
  }
}
