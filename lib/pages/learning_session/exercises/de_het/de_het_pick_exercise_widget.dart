import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:first_project/pages/learning_session/exercises/shared/exercise_evaluation_widget.dart';
import 'package:first_project/pages/learning_session/notifiers/notifier_tools.dart';
import 'package:first_project/styles/button_styles.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class DeHetPickExerciseWidget extends StatefulWidget {
  final DeHetPickExercise exercise;

  const DeHetPickExerciseWidget(this.exercise, {super.key});

  @override
  State<DeHetPickExerciseWidget> createState() =>
      _DeHetPickExerciseWidgetState();
}

class _DeHetPickExerciseWidgetState extends State<DeHetPickExerciseWidget> {
  bool? isCorrectAnswer;
  // differs from exercise.isAnswered - answer is for current widget only
  bool isExerciseAnswered = false;

  void onAnswerProvided(DeHetType answer) {
    setState(() {
      isExerciseAnswered = true;
      isCorrectAnswer = widget.exercise.isCorrectAnswer(answer);
    });
    notifyAnsweredExercise(context, true);
    widget.exercise.processAnswer(answer);
  }

  Widget _buildContent(BuildContext context) {
    return ExerciseContent(
      promptBuilder: _buildPrompt,
      inputDataBuilder: _buildInputData,
      evaluationBuilder: _buildEvaluation,
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      "Select 'De' or 'Het' for the following word:",
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  RichText _buildInputData(BuildContext context) {
    return RichText(
        text: TextSpan(
      style: TextStyles.exerciseInputDataStyle(context),
      children: <TextSpan>[
        _buildWordPrefix(),
        const TextSpan(text: ' '),
        TextSpan(text: widget.exercise.word.dutchWord),
      ],
    ));
  }

  // Shows de/het after answer was provided, and paints it with proper color
  TextSpan _buildWordPrefix() {
    if (!isExerciseAnswered) {
      return const TextSpan(text: '___');
    }
    var color = isCorrectAnswer!
        ? TextStyles.evaluationSuccessTextColor
        : TextStyles.evaluationErrorTextColor;
    return TextSpan(
        text: widget.exercise.word.deHetType.name,
        style: TextStyle(color: color));
  }

  Widget _buildEvaluation(context) {
    return ExerciseEvaluation(
        isExerciseAnswered: isExerciseAnswered,
        isCorrectAnswer: isCorrectAnswer);
  }

  Widget _buildFooter(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildAnswerOptionButton(DeHetType.de, "De"),
        ),
        const SizedBox(width: ContainerStyles.defaultPadding),
        Expanded(
          child: _buildAnswerOptionButton(DeHetType.het, "Het"),
        ),
      ],
    );
  }

  TextButton _buildAnswerOptionButton(DeHetType deHetType, String buttonText) {
    return TextButton(
      onPressed: isExerciseAnswered
          ? null
          : () {
              onAnswerProvided(deHetType);
            },
      style: ButtonStyles.secondaryButtonStyle(context),
      child: Text(
        buttonText,
      ),
    );
  }

  // ==== Main

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
        contentBuilder: _buildContent, footerBuilder: _buildFooter);
  }
}
