import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_row_data.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class VerbConjugationTable extends StatelessWidget {
  final List<VerbConjugationRowData> rows;
  const VerbConjugationTable({super.key, required this.rows});

  TextStyle _buildTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: Theme.of(
        context,
      ).textTheme.bodyMedium?.color?.withAlpha((0.7 * 255).round()),
    );
  }

  TableRow _buildThreeColumnRow(VerbConjugationRowData rowData) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Builder(
            builder: (context) => SelectableText(
              rowData.pronoun,
              textAlign: TextAlign.end,
              style: _buildTextStyle(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Builder(
            builder: (context) => TextField(
              controller: rowData.controller,
              decoration: _buildInputDecoration(context, rowData.inputHint),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Builder(
            builder: (context) =>
                SelectableText(rowData.suffix, style: _buildTextStyle(context)),
          ),
        ),
      ],
    );
  }

  static InputDecoration _buildInputDecoration(
    BuildContext context,
    String? inputHint,
  ) {
    final theme = Theme.of(context);
    final onSurfaceWithOpacity = theme.colorScheme.onSurface.withAlpha(
      (0.6 * 255).round(),
    );
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      hintText: inputHint,
      hintStyle: TextStyle(color: TextStyles.dropdownGreyTextColor(context)),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: onSurfaceWithOpacity, width: 1.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: onSurfaceWithOpacity, width: 1.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [for (var row in rows) _buildThreeColumnRow(row)],
    );
  }
}
