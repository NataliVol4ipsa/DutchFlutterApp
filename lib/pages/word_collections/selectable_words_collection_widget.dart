import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWordCollectionRow extends StatelessWidget {
  final bool showCheckbox;
  final SelectableWordCollectionModel collection;
  final Function(SelectableWordCollectionModel) onRowTap;
  final void Function() onLongRowPress;
  const SelectableWordCollectionRow(
      {super.key,
      required this.collection,
      required this.onRowTap,
      required this.showCheckbox,
      required this.onLongRowPress});

  Color _textColor(BuildContext context) {
    return collection.isSelected
        ? ContainerStyles.selectedPrimaryTextColor(context)
        : ContainerStyles.sectionTextColor(context);
  }

  Color _backgroundColor(BuildContext context) {
    return collection.isSelected
        ? ContainerStyles.selectedPrimaryColor(context)
        : ContainerStyles.sectionColor(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onRowTap(collection)},
      onLongPress: onLongRowPress,
      child: Container(
          color: _backgroundColor(context),
          padding: ContainerStyles.smallContainerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                collection.name,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _textColor(context)),
              ),
              if (showCheckbox)
                MyCheckbox(
                    value: collection.isSelected,
                    onChanged: (value) => {onRowTap(collection)}),
            ],
          )),
    );
  }
}
