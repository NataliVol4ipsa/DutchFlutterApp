import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ManyToManyExerciseWidget extends StatefulWidget {
  final ManyToManyExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;
  const ManyToManyExerciseWidget(
      {super.key,
      required this.exercise,
      required this.onNextButtonPressed,
      required this.nextButtonText});

  @override
  State<ManyToManyExerciseWidget> createState() =>
      _ManyToManyExerciseWidgetState();
}

class _ManyToManyExerciseWidgetState extends State<ManyToManyExerciseWidget> {
  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: _buildPrompt(context),
            )),
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOptionsColumn(widget.exercise.leftOptions, true),
                _buildOptionsColumn(widget.exercise.rightOptions, false),
              ],
            )),
      ],
    );
  }

  Widget _buildOptionsColumn(
      List<ManyToManyOption> options, bool isLeftColumn) {
    var optionItems =
        options.map((opt) => _buildSingleOption(opt, isLeftColumn)).toList();
    return Column(
      children: optionItems,
    );
  }

  void _handleLeftOptionClick(ManyToManyOption option) {}
  void _handleRightOptionClick(ManyToManyOption option) {}

// todo handle multiline
  Widget _buildSingleOption(ManyToManyOption option, bool isLeftColumn) {
    return TextButton(
        style: ButtonStyles.mediumSecondaryButtonStyle(context),
        onPressed: () => !option.isActive
            ? null
            : isLeftColumn
                ? _handleLeftOptionClick(option)
                : _handleRightOptionClick(option),
        child: Text(option.word));
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      "Match words with their translations:",
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter(context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
        contentBuilder: _buildContent, footerBuilder: _buildFooter);
  }
}
