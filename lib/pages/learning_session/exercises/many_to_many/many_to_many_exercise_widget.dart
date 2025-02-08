import 'package:collection/collection.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_option.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
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
  void _handleLeftOptionClick(ManyToManyOption leftOption) {
    if (!leftOption.isActive) return;

    bool currentOptionCurrentState = leftOption.isSelected;

    var selectedRight =
        widget.exercise.rightOptions.firstWhereOrNull((op) => op.isSelected);

    if (selectedRight == null) {
      setState(() {
        for (int i = 0; i < widget.exercise.rightOptions.length; i++) {
          widget.exercise.rightOptions[i].isSelected = false;
        }
        leftOption.isSelected = !currentOptionCurrentState;
      });
      return;
    }

    _handleTwoOptionsSelected(leftOption, selectedRight);
  }

  void _handleRightOptionClick(ManyToManyOption rightOption) {
    if (!rightOption.isActive) return;

    bool currentOptionCurrentState = rightOption.isSelected;

    var selectedLeft =
        widget.exercise.leftOptions.firstWhereOrNull((op) => op.isSelected);

    if (selectedLeft == null) {
      setState(() {
        for (int i = 0; i < widget.exercise.rightOptions.length; i++) {
          widget.exercise.rightOptions[i].isSelected = false;
        }
        rightOption.isSelected = !currentOptionCurrentState;
      });
      return;
    }

    _handleTwoOptionsSelected(selectedLeft, rightOption);
  }

  void _handleTwoOptionsSelected(
      ManyToManyOption left, ManyToManyOption right) {
    setState(() {
      if (widget.exercise.processAnswer(left, right)) {
        left.isActive = false;
        right.isActive = false;
        left.isSelected = false;
        right.isSelected = false;
      } else {}
    });
  }

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
                SizedBox(
                  width: ContainerStyles.defaultPadding,
                ),
                _buildOptionsColumn(widget.exercise.rightOptions, false),
              ],
            )),
      ],
    );
  }

  Widget _buildOptionsColumn(
      List<ManyToManyOption> options, bool isLeftColumn) {
    return Expanded(
      child: Column(
        children: List.generate(
          options.length * 2 - 1,
          (index) {
            if (index.isEven) {
              return _buildSingleOption(options[index ~/ 2], isLeftColumn);
            } else {
              return SizedBox(height: ContainerStyles.defaultPadding);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSingleOption(ManyToManyOption option, bool isLeftColumn) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          style: ButtonStyles.manyToManyOptionButtonStyle(
              context, option.isSelected),
          onPressed: !option.isActive
              ? null
              : () {
                  isLeftColumn
                      ? _handleLeftOptionClick(option)
                      : _handleRightOptionClick(option);
                },
          child: Text(
            option.word,
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: 3,
          )),
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      "Match words with their translations:",
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter(context) {
    return Opacity(
      opacity: widget.exercise.isAnswered() ? 1.0 : 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Expanded(child: _buildNextButton())],
      ),
    );
  }

  TextButton _buildNextButton() {
    return TextButton(
      onPressed:
          widget.exercise.isAnswered() ? widget.onNextButtonPressed : null,
      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
      child: Text(
        widget.nextButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
        contentBuilder: _buildContent, footerBuilder: _buildFooter);
  }
}
