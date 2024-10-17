import 'package:flutter/material.dart';
import 'package:first_project/core/models/word.dart';

class WordTable extends StatelessWidget {
  final List<Word> words;
  final List<bool> selectedRows;
  final bool isMultiselectModeEnabled;
  final bool? selectAllCheckboxValue;
  final Function(int, bool?) onRowCheckboxChanged;
  final Function(bool?) onSelectAllCheckboxValueChanged;
  final Function(Word) onRowTap;

  const WordTable({
    super.key,
    required this.words,
    required this.selectedRows,
    required this.isMultiselectModeEnabled,
    required this.selectAllCheckboxValue,
    required this.onRowCheckboxChanged,
    required this.onSelectAllCheckboxValueChanged,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: generateTableColWidths(),
      children: [
        TableRow(
          children: [
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '#',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Dutch',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'English',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isMultiselectModeEnabled) ...[
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: Checkbox(
                    tristate: true,
                    value: selectAllCheckboxValue,
                    onChanged: onSelectAllCheckboxValueChanged,
                  ),
                ),
              ),
            ],
          ],
        ),
        ...words.asMap().entries.map((entry) {
          int index = entry.key + 1;
          Word word = entry.value;
          return TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: GestureDetector(
                  onTap: () => onRowTap(word),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(index.toString()),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: GestureDetector(
                  onTap: () => onRowTap(word),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(word.dutchWord),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: GestureDetector(
                  onTap: () => onRowTap(word),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(word.englishWord),
                  ),
                ),
              ),
              if (isMultiselectModeEnabled) ...[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Checkbox(
                      value: selectedRows[entry.key],
                      onChanged: (isSelected) =>
                          onRowCheckboxChanged(entry.key, isSelected),
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ],
    );
  }

  Map<int, TableColumnWidth> generateTableColWidths() {
    if (isMultiselectModeEnabled) {
      return {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(10),
        2: const FlexColumnWidth(10),
        3: const FlexColumnWidth(2),
      };
    }
    return {
      0: const FlexColumnWidth(2),
      1: const FlexColumnWidth(10),
      2: const FlexColumnWidth(10),
    };
  }
}
