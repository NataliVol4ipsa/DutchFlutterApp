import 'package:dutch_app/pages/word_editor/online_search/models/selectable_string.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/base/translation_card_section_widget.dart';
import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/reusable_widgets/input_icons.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class OnlineTranslationWordTranslations extends StatefulWidget {
  const OnlineTranslationWordTranslations({
    super.key,
    required this.translation,
  });

  final TranslationSearchResult translation;

  @override
  State<OnlineTranslationWordTranslations> createState() =>
      _OnlineTranslationWordTranslationsState();
}

class _OnlineTranslationWordTranslationsState
    extends State<OnlineTranslationWordTranslations> {
  @override
  void initState() {
    super.initState();

    if (widget.translation.translationWords.isNotEmpty) {
      widget.translation.translationWords.first.select();
    }
  }

  void toggleSelection(SelectableString word) {
    setState(() {
      if (word.isSelected) {
        if (widget.translation.translationWords
                .where((w) => w.isSelected)
                .length <=
            1) {
          return;
        }
        word.unselect();
      } else {
        word.select();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 8),
      TranslationCardSection(
          name: 'Translations',
          icon: InputIcons.englishWord,
          topPaddingOverride: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createTooltip(context),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.translation.translationWords.map((word) {
                  return FilterChip(
                    selectedColor: ContainerStyles.chipColor(context),
                    label: Text(word.value,
                        style: TextStyle(
                            fontSize: OnlineTranslationFonts
                                .sectionChipMultiselectFontSize,
                            color: ContainerStyles.chipTextColor(context))),
                    showCheckmark: false,
                    selected: word.isSelected,
                    onSelected: (selected) => toggleSelection(word),
                  );
                }).toList(),
              ),
            ],
          )),
    ]);
  }

  Widget _createTooltip(BuildContext context) {
    if (widget.translation.translationWords.length <= 1) return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 2.0),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: BaseStyles.getColorScheme(context).onSurfaceVariant,
            size: OnlineTranslationFonts.sectionTooltipFontSize + 2,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: OnlineTranslationFonts.sectionTooltipFontSize,
                color: BaseStyles.getColorScheme(context).onSurfaceVariant,
              ),
              text: "  Select (at least) one or multiple translations",
            ),
          ),
        ],
      ),
    );
  }
}
