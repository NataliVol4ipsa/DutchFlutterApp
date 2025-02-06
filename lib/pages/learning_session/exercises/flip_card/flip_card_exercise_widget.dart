import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/core/notifiers/notifier_tools.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class FlipCardExerciseWidget extends StatefulWidget {
  final FlipCardExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const FlipCardExerciseWidget(this.exercise,
      {required this.onNextButtonPressed,
      required this.nextButtonText,
      super.key});

  @override
  State<FlipCardExerciseWidget> createState() => _FlipCardExerciseWidgetState();
}

class _FlipCardExerciseWidgetState extends State<FlipCardExerciseWidget> {
  bool? userKnowsTrasnslation;
  bool showTranslation = false;
  // differs from exercise.isAnswered - answer is for current widget only
  bool isExerciseAnswered = false;

  Future<void> onAnswerProvided(bool userKnowsTrasnslationInput) async {
    setState(() {
      isExerciseAnswered = true;
      userKnowsTrasnslation = userKnowsTrasnslationInput;
    });
    widget.exercise.processAnswer(userKnowsTrasnslation!);
    notifyAnsweredExercise(context, true); //move to base?
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
      evaluationBuilder: ((context) => Container()),
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      "Do you know the translation of following word?",
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
              )
            },
          ],
        ),
        Opacity(
          opacity: showTranslation ? 1.0 : 0.0,
          child: Text(
            widget.exercise.word.englishWord,
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
          onPressed: () {
            onShowTranslationClicked();
          },
          style: ButtonStyles.largePrimaryButtonStyle(context),
          child: const Text(
            "Show translation",
          ),
        )),
      ],
    );
  }

  Widget _buildAnswerOptionsFooter(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildAnswerOptionButton(true, "Know"),
        ),
        const SizedBox(width: ContainerStyles.defaultPadding),
        Expanded(
          child: _buildAnswerOptionButton(false, "Don't know"),
        ),
      ],
    );
  }

  TextButton _buildAnswerOptionButton(bool userClickedKnow, String buttonText) {
    return TextButton(
      onPressed: () {
        onAnswerProvided(userClickedKnow);
        //
      },
      style: ButtonStyles.largePrimaryButtonStyle(context),
      child: Text(
        maxLines: 1,
        softWrap: false,
        buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
        contentBuilder: _buildContent, footerBuilder: _buildFooter);
  }
}
