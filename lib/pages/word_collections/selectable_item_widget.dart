import 'package:dutch_app/pages/word_collections/selectable_models/selectable_item_model.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableItem<T> extends StatelessWidget {
  final SelectableItemModel<T> item;
  final bool showCheckbox;
  final double extraLeftPadding;
  final void Function(SelectableItemModel<T>) onRowTap;
  final void Function()? onLongRowPress;
  const SelectableItem(
      {super.key,
      required this.item,
      required this.onRowTap,
      this.onLongRowPress,
      required this.showCheckbox,
      this.extraLeftPadding = 0});

  Color _backgroundColor(BuildContext context) {
    return item.isSelected
        ? ContainerStyles.selectedSecondaryColor(context)
        : ContainerStyles.backgroundColor(context);
  }

  Color _textColor(BuildContext context) {
    return item.isSelected
        ? ContainerStyles.selectedSecondaryTextColor(context)
        : ContainerStyles.backgroundTextColor(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onRowTap(item)},
      onLongPress: onLongRowPress,
      child: Container(
          color: _backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Padding(
            padding: EdgeInsets.only(left: extraLeftPadding),
            child: Row(
              children: [
                if (showCheckbox)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: ContainerStyles.defaultPadding),
                    child: MyCheckbox(
                        value: item.isSelected,
                        onChanged: (value) => {onRowTap(item)}),
                  ),
                Expanded(
                  child: Text(
                    item.displayValue,
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
