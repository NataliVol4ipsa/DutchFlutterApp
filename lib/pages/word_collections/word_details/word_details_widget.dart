import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/word_editor/inputs/generic/form_input_icon_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class WordDetails extends StatelessWidget {
  final Word word;
  const WordDetails({super.key, required this.word});

  Widget _buildHeader(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      color: ContainerStyles.bottomNavBarColor(context),
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
              onPressed: () {},
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
        Text(
          word.toDutchWordString(),
          style: TextStyles.titleStyle,
        ),
        Text(
          word.wordType.label,
          style: TextStyles.titleCommentStyle,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text("Details");
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
