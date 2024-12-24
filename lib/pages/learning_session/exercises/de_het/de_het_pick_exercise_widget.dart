import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/pages/learning_session/notifiers/notifier_tools.dart';
import 'package:first_project/styles/button_styles.dart';
import 'package:first_project/styles/container_styles.dart';
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

  // COLORS
  late ColorScheme colorScheme;

  late Color assignmentTextColor;
  late Color? assignmentBackgroundColor;

  late Color questionTextColor;
  late Color? questionBackgroundColor;

  late Color evaluationSuccessTextColor;
  late Color evaluationErrorTextColor;
  late Color? evaluationBackgroundColor;

  late Color answerOptionButtonTextColor;
  late Color? answerOptionButtonBackgroundColor;

  late Color answerOptionButtonDisabledTextColor;
  late Color? answerOptionButtonDisabledBackgroundColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setColors();
  }

  void setColors() {
    colorScheme = Theme.of(context).colorScheme;

    assignmentTextColor = colorScheme.onPrimaryContainer;
    assignmentBackgroundColor = null;

    questionTextColor = colorScheme.onSurfaceVariant;
    questionBackgroundColor = colorScheme.surfaceVariant;

    evaluationSuccessTextColor = Colors.green;
    evaluationErrorTextColor = Colors.red;
    evaluationBackgroundColor = null;

    answerOptionButtonTextColor = colorScheme.onPrimaryContainer;
    answerOptionButtonBackgroundColor = colorScheme.primaryContainer;

    answerOptionButtonDisabledTextColor =
        answerOptionButtonTextColor.withOpacity(0.5);
    answerOptionButtonDisabledBackgroundColor =
        answerOptionButtonBackgroundColor?.withOpacity(0.5);
  }

  void onAnswerProvided(DeHetType answer) {
    setState(() {
      isExerciseAnswered = true;
      isCorrectAnswer = widget.exercise.isCorrectAnswer(answer);
    });
    notifyAnsweredExercise(context, true);
    widget.exercise.processAnswer(answer);
  }

  // ==== Assignment

  Widget _buildAssignmentLayout() {
    return Text(
      "Select 'De' or 'Het' for the following word:",
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: assignmentTextColor),
      textAlign: TextAlign.center,
    );
  }

  // ==== Question

  RichText _buildQuestionLayout(String text) {
    return RichText(
        text: TextSpan(
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: questionTextColor),
      children: <TextSpan>[
        _buildWordPrefix(),
        const TextSpan(text: ' '),
        TextSpan(text: widget.exercise.word.dutchWord),
      ],
    ));
  }

  TextSpan _buildWordPrefix() {
    if (!isExerciseAnswered) {
      return const TextSpan(text: '___');
    }
    var color = isCorrectAnswer!
        ? evaluationSuccessTextColor
        : evaluationErrorTextColor;
    return TextSpan(
        text: widget.exercise.word.deHetType.name,
        style: TextStyle(color: color));
  }

  // ==== Evaluation

  Text buildEvaluationText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget buildEvaluationLayout() {
    if (!isExerciseAnswered) {
      return buildEvaluationText(' ');
    }

    if (isCorrectAnswer == true) {
      return buildEvaluationText("Correct!", color: evaluationSuccessTextColor);
    }

    return buildEvaluationText("Wrong!", color: evaluationErrorTextColor);
  }

  // ==== Answer options

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
        //todo reuse for Next and Finish buttons
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==== Primary sections

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: assignmentBackgroundColor,
              alignment: Alignment.center,
              child: _buildAssignmentLayout(),
            )),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: questionBackgroundColor,
            ),
            alignment: Alignment.center,
            child: _buildQuestionLayout('123'),
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
                decoration: BoxDecoration(
                    color: evaluationBackgroundColor,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: buildEvaluationLayout())),
      ],
    );
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

  // ==== Main

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
        contentBuilder: _buildContent, footerBuilder: _buildFooter);
  }
}
