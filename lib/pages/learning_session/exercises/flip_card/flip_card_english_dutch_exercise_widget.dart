import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_english_dutch_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FlipCardEnglishDutchExerciseWidget extends StatefulWidget {
  final FlipCardEnglishDutchExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const FlipCardEnglishDutchExerciseWidget(
    this.exercise, {
    required this.onNextButtonPressed,
    required this.nextButtonText,
    super.key,
  });

  @override
  State<FlipCardEnglishDutchExerciseWidget> createState() =>
      _FlipCardEnglishDutchExerciseWidgetState();
}

class _FlipCardEnglishDutchExerciseWidgetState
    extends State<FlipCardEnglishDutchExerciseWidget> {
  bool? userKnowsTranslation;
  bool showTranslation = false;
  bool isExerciseAnswered = false;

  Future<void> onAnswerProvided(bool userKnowsTranslationInput) async {
    setState(() {
      isExerciseAnswered = true;
      userKnowsTranslation = userKnowsTranslationInput;
    });
    widget.exercise.processAnswer(userKnowsTranslation!);
    notifyAnsweredExercise(context, true);
    await widget.onNextButtonPressed();
  }

  void onShowTranslationClicked() {
    setState(() {
      showTranslation = true;
    });
  }

  Widget _buildContent(BuildContext context) {
    return ExerciseContent(
      promptBuilder: _buildPrompt,
      inputDataBuilder: _buildInputData,
      evaluationBuilder: (context) => Container(),
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      "Do you know the Dutch translation?",
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInputData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              widget.exercise.inputWord,
              style: TextStyles.exerciseInputDataStyle(context),
              textAlign: TextAlign.center,
            ),
            if (widget.exercise.hint != null) ...{
              Text(
                widget.exercise.hint!,
                style: TextStyles.exerciseInputDataHintStyle(context),
                textAlign: TextAlign.center,
              ),
            },
          ],
        ),
        Opacity(
          opacity: showTranslation ? 1.0 : 0.0,
          child: Text(
            widget.exercise.correctAnswer,
            style: TextStyles.exerciseInputDataAnswerStyle(context),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(context) {
    return showTranslation
        ? _buildAnswerOptionsFooter(context)
        : _buildShowTranslationFooter(context);
  }

  Widget _buildShowTranslationFooter(context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onShowTranslationClicked,
            style: ButtonStyles.largeWidePrimaryButtonStyle(context),
            child: const Text("Show Dutch translation"),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOptionsFooter(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildAnswerOptionButton(true, "Know")),
        const SizedBox(width: ContainerStyles.defaultPaddingAmount),
        Expanded(child: _buildAnswerOptionButton(false, "Don't know")),
      ],
    );
  }

  TextButton _buildAnswerOptionButton(bool userClickedKnow, String buttonText) {
    return TextButton(
      onPressed: () => onAnswerProvided(userClickedKnow),
      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
      child: Text(maxLines: 1, softWrap: false, buttonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
      contentBuilder: _buildContent,
      footerBuilder: _buildFooter,
    );
  }
}
