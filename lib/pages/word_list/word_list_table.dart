import 'package:first_project/pages/word_list/word_list_table_row.dart';
import 'package:flutter/material.dart';
import 'package:first_project/core/models/word.dart';

class WordTable extends StatelessWidget {
  final List<Word> words;
  final List<bool> selectedRows;
  final bool isMultiselectModeEnabled;
  final bool? selectAllCheckboxValue;
  final Function(int, bool?) onRowCheckboxChanged;
  final Function(bool?) onSelectAllCheckboxValueChanged;
  final Function(int, Word) onRowTap;
  final ScrollController scrollController;
  final Function(int)? onRowLongPress;

  const WordTable({
    super.key,
    required this.words,
    required this.selectedRows,
    required this.isMultiselectModeEnabled,
    required this.selectAllCheckboxValue,
    required this.onRowCheckboxChanged,
    required this.onSelectAllCheckboxValueChanged,
    required this.onRowTap,
    required this.scrollController,
    this.onRowLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          color: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.all(4.0),
                child: headerText("No.", theme),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: headerText("Dutch Word", theme),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: headerText("English Word", theme),
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
                      value: selectAllCheckboxValue,
                      tristate: true,
                      onChanged: onSelectAllCheckboxValueChanged,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return WordTableRow(
                color: index.isEven
                    ? theme.colorScheme.surface
                    : Color.alphaBlend(Colors.black.withOpacity(0.05),
                        theme.colorScheme.surface),
                index: index,
                word: word,
                isSelected: selectedRows[index],
                isMultiselectModeEnabled: isMultiselectModeEnabled,
                onRowCheckboxChanged: (value) =>
                    onRowCheckboxChanged(index, value),
                onRowTap: () => onRowTap(index, word),
                onRowLongPress: onRowLongPress,
              );
            },
          ),
        ),
      ],
    );
  }

  Text headerText(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
    );
  }
}
