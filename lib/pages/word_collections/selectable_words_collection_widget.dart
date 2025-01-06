import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection.dart';
import 'package:dutch_app/reusable_widgets/my_checkbox.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SelectableWordCollectionRow extends StatelessWidget {
  final SelectableWordCollectionModel collection;
  final Function(SelectableWordCollectionModel) onSelectCollectionTap;
  const SelectableWordCollectionRow(
      {super.key,
      required this.collection,
      required this.onSelectCollectionTap});

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
      onTap: () => {onSelectCollectionTap(collection)},
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
              MyCheckbox(
                  value: collection.isSelected,
                  onChanged: (value) => {onSelectCollectionTap(collection)}),
            ],
          )),
    );
  }
}
