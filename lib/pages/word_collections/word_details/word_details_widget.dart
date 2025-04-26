import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/word_collections/dialogs/delete_words_dialog.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/reusable_widgets/Input_icons.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class WordDetails extends StatelessWidget {
  final Word word;
  final Future<void> Function()? deletionCallback;
  WordDetails({super.key, required this.word, this.deletionCallback});

  final _horizontalPadding = ContainerStyles.smallPaddingAmount;

  void _showDeleteSingleWordDialog(BuildContext context) {
    showDeleteWordsDialog(
      context: context,
      collectionIds: [],
      wordIds: [word.id],
      callback: (() async {
        Navigator.pop(context);
        if (deletionCallback != null) {
          await deletionCallback!();
        }
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      color: ContainerStyles.bottomNavBarColor(context),
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: Padding(
              padding: ContainerStyles.smallContainerPadding2,
              child: Container(
                  alignment: Alignment.center,
                  child: const Icon(Icons.menu_book)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: ContainerStyles.smallContainerPadding,
              child: _buildWordTitle(context),
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: const FormInputIcon(Icons.edit),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/wordeditor', arguments: word.id);
              },
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: const FormInputIcon(Icons.delete),
              onPressed: () {
                _showDeleteSingleWordDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          word.toDutchWordString(),
          style: TextStyles.titleStyle
              .copyWith(color: BaseStyles.getColorScheme(context).primary),
        ),
        SelectableText(
          word.wordType.label,
          style: TextStyles.titleCommentStyle,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ContainerStyles.smallPaddingAmount,
          horizontal: _horizontalPadding),
      child: ListView(shrinkWrap: true, children: [
        ..._buildTranslation(context),
        ..._buildPlural(context),
        ..._buildCollection(context),
        ..._buildContextExample(context),
        ..._buildUserNote(context),
      ]),
    );
  }

  List<Widget> _buildPlural(BuildContext context) {
    if (word.pluralForm == null || word.pluralForm!.trim() == "") return [];

    return _buildBodySectionGeneric(context,
        sectionName: "Plural form",
        prefixIcon: InputIcons.dutchPluralForm,
        content: SelectableText(word.pluralForm!,
            style: TextStyles.wordDetailsSectionContentStyle));
  }

  List<Widget> _buildTranslation(BuildContext context) {
    return _buildBodySectionGeneric(context,
        sectionName: "Translation",
        prefixIcon: InputIcons.englishWord,
        content: SelectableText(word.englishWord,
            style: TextStyles.wordDetailsSectionContentStyle));
  }

  List<Widget> _buildCollection(BuildContext context) {
    return _buildBodySectionGeneric(context,
        sectionName: "Collection",
        prefixIcon: InputIcons.collection,
        content: SelectableText(word.collection!.name,
            style: TextStyles.wordDetailsSectionContentStyle));
  }

  List<Widget> _buildContextExample(BuildContext context) {
    if (word.contextExample == null || word.contextExample!.trim() == "") {
      return [];
    }

    return _buildBodySectionGeneric(context,
        sectionName:
            "Example in context", //todo reuse labels here and in word editor
        prefixIcon: InputIcons.contextExample,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText("\"${word.contextExample!}\"",
                style: TextStyles.wordDetailsSectionContentStyle),
            if (word.contextExampleTranslation != null &&
                word.contextExampleTranslation!.trim() != "") ...[
              SizedBox(
                height: ContainerStyles.betweenCardsPaddingAmount,
              ),
              SelectableText("(${word.contextExampleTranslation!})",
                  style: TextStyles.smallWordDetailsSectionContentStyle)
            ]
          ],
        ));
  }

  List<Widget> _buildUserNote(BuildContext context) {
    if (word.userNote == null || word.userNote!.trim() == "") {
      return [];
    }
    return _buildBodySectionGeneric(context,
        sectionName: "Notes",
        prefixIcon: InputIcons.userNote,
        content: SelectableText(word.userNote!,
            style: TextStyles.wordDetailsSectionContentStyle));
  }

  List<Widget> _buildBodySectionGeneric(BuildContext context,
      {required String sectionName,
      required Widget content,
      IconData? prefixIcon}) {
    return [
      Padding(
        padding:
            EdgeInsets.symmetric(vertical: ContainerStyles.smallPaddingAmount2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ContainerStyles.smallPaddingAmount2),
                  child: Icon(
                    prefixIcon,
                    size: 24,
                    color: BaseStyles.getColorScheme(context).onSurfaceVariant,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(sectionName,
                        style: TextStyles.wordDetailsSectionTitleStyle.copyWith(
                          color: BaseStyles.getColorScheme(context)
                              .onSurfaceVariant,
                        )),
                    Divider(),
                    content,
                  ],
                ),
              ),
            ],
          ),
        ]),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: _buildHeader(context),
        ),
        Expanded(
          child: _buildBody(context),
        )
      ],
    );
  }
}
