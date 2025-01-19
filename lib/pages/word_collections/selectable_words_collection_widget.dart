import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection_model.dart';
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

  bool? _calculateCheckBoxValue() {
    if (collection.words?.isEmpty ?? true) {
      return collection.isSelected;
    }
    int selectedWordsCount =
        collection.words?.where((word) => word.isSelected).length ?? 0;
    if (selectedWordsCount == 0) {
      return false;
    }
    if (collection.words!.length != selectedWordsCount) {
      return null;
    }
    return true;
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
            children: [
              if (showCheckbox)
                Padding(
                    padding: const EdgeInsets.only(
                        right: ContainerStyles.defaultPadding),
                    child: MyCheckbox(
                        tristate: true,
                        value: _calculateCheckBoxValue(),
                        onChanged: (value) => {onRowTap(collection)})),
              Text(
                collection.name,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _textColor(context)),
              ),
            ],
          )),
    );
  }
}
