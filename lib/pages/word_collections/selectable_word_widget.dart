import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word_model.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWord extends StatelessWidget {
  final SelectableWordModel word;
  final bool showCheckbox;
  final double extraLeftPadding;
  final void Function(SelectableWordModel) onRowTap;
  final void Function()? onLongRowPress;
  const SelectableWord(
      {super.key,
      required this.word,
      required this.onRowTap,
      this.onLongRowPress,
      required this.showCheckbox,
      this.extraLeftPadding = 0});

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
    return GestureDetector(
      onTap: () => {onRowTap(word)},
      onLongPress: onLongRowPress,
      child: Container(
          color: _backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Padding(
            padding: EdgeInsets.only(left: extraLeftPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showCheckbox)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: ContainerStyles.defaultPadding),
                    child: MyCheckbox(
                        value: word.isSelected,
                        onChanged: (value) => {onRowTap(word)}),
                  ),
                Expanded(
                  child: Text(
                    word.displayValue,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _textColor(context)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
