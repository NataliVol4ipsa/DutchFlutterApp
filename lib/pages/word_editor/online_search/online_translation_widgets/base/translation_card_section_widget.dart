import 'package:dutch_app/pages/word_editor/online_search/online_translation_widgets/online_translation_fonts.dart';
import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class TranslationCardSection extends StatelessWidget {
  final Widget child;
  final String name;
  final IconData icon;

  const TranslationCardSection({
    super.key,
    required this.child,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ContainerStyles.smallPaddingAmount2),
                child: Icon(
                  icon,
                  size: 20,
                  color: BaseStyles.getColorScheme(context).onSurfaceVariant,
                )),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: OnlineTranslationFonts.sectionTitleFontSize,
                  color: BaseStyles.getColorScheme(context).onSurfaceVariant,
                ),
                text: name,
              ),
            ),
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        )
      ],
    );
  }
}
