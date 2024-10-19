import 'package:flutter/material.dart';
import 'package:first_project/core/models/word.dart';

class WordTableRow extends StatelessWidget {
  final int index;
  final Word word;
  final bool isSelected;
  final bool isMultiselectModeEnabled;
  final Function(bool?) onRowCheckboxChanged;
  final Function() onRowTap;
  final Function(int)? onRowLongPress;
  final Color? color;

  const WordTableRow({
    super.key,
    required this.index,
    required this.word,
    required this.isSelected,
    required this.isMultiselectModeEnabled,
    required this.onRowCheckboxChanged,
    required this.onRowTap,
    this.onRowLongPress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRowTap,
      onLongPress: () => {
        if (onRowLongPress != null) {onRowLongPress!(index)}
      },
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              padding: const EdgeInsets.all(4.0),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  word.dutchWord,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  word.englishWord,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            if (isMultiselectModeEnabled)
              Container(
                width: 50,
                padding: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onRowCheckboxChanged,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
