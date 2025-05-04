import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word_model.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWord extends StatelessWidget {
  final bool? isEvenRow;
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
      this.extraLeftPadding = 0,
      this.isEvenRow});

  Color _backgroundColor(BuildContext context) {
    if (word.isSelected) return ContainerStyles.selectedSecondaryColor(context);
    if (isEvenRow == null || !isEvenRow!) {
      return Color.lerp(ContainerStyles.backgroundColor(context),
          BaseStyles.getColorScheme(context).tertiary, 0.05)!;
    }
    return ContainerStyles.backgroundColor(context);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showCheckbox)
                Padding(
                  padding: const EdgeInsets.only(
                      right: ContainerStyles.defaultPaddingAmount),
                  child: MyCheckbox(
                      value: word.isSelected,
                      onChanged: (value) => {onRowTap(word)}),
                ),
              SizedBox(
                width: 30,
                child: Text(
                  word.value.deHetType.emptyOnNone,
                  style: TextStyle(color: _textColor(context)),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  word.value.dutchWord,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _textColor(context)),
                ),
              ),
              SizedBox(
                width: ContainerStyles.betweenCardsPaddingAmount,
              ),
              Expanded(
                child: Text(
                  word.value.englishWord,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _textColor(context)),
                ),
              ),
            ],
          )),
    );
  }
}
