import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_evaluation_widget.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class DeHetPickExerciseWidget extends StatefulWidget {
  final DeHetPickExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const DeHetPickExerciseWidget(this.exercise,
      {required this.onNextButtonPressed,
      required this.nextButtonText,
      super.key});

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
    widget.exercise.processAnswer(answer);
    notifyAnsweredExercise(context, true); //move to base?
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

  Widget _buildInputData(BuildContext context) {
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
        ? TextStyles.successTextColor
        : TextStyles.failureTextColor;
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildFooterButtons(),
    );
  }

  List<Widget> _buildFooterButtons() {
    if (isExerciseAnswered) {
      return [Expanded(child: _buildNextButton())];
    }

    return [
      Expanded(
        child: _buildAnswerOptionButton(DeHetType.de, "De"),
      ),
      const SizedBox(width: ContainerStyles.defaultPaddingAmount),
      Expanded(
        child: _buildAnswerOptionButton(DeHetType.het, "Het"),
      ),
    ];
  }

  TextButton _buildNextButton() {
    return TextButton(
      onPressed: widget.onNextButtonPressed,
      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
      child: Text(
        widget.nextButtonText,
      ),
    );
  }

  TextButton _buildAnswerOptionButton(DeHetType deHetType, String buttonText) {
    return TextButton(
      onPressed: isExerciseAnswered
          ? null
          : () {
              onAnswerProvided(deHetType);
            },
      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
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
