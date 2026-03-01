import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_evaluation_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

enum _AnswerState { pending, correct, nearCorrect, wrong }

class WriteExerciseWidget extends StatefulWidget {
  final WriteExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const WriteExerciseWidget(
    this.exercise, {
    required this.onNextButtonPressed,
    required this.nextButtonText,
    super.key,
  });

  @override
  State<WriteExerciseWidget> createState() => _WriteExerciseWidgetState();
}

class _WriteExerciseWidgetState extends State<WriteExerciseWidget> {
  final TextEditingController _textController = TextEditingController();
  _AnswerState _answerState = _AnswerState.pending;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onCheckPressed() {
    final normalised = WriteExercise.normaliseInput(_textController.text);
    final correctAnswer = widget.exercise.word.dutchWord;

    final distance = WriteExercise.levenshteinDistance(
      normalised,
      correctAnswer,
    );

    final _AnswerState state;
    final bool isCorrect;

    if (normalised.toLowerCase() == correctAnswer.toLowerCase()) {
      state = _AnswerState.correct;
      isCorrect = true;
    } else if (distance == 1) {
      state = _AnswerState.nearCorrect;
      isCorrect = true;
    } else {
      state = _AnswerState.wrong;
      isCorrect = false;
    }

    setState(() => _answerState = state);
    widget.exercise.processAnswer(isCorrect);
    // Dismiss the software keyboard.
    FocusScope.of(context).unfocus();
    notifyAnsweredExercise(context, true);
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      'Write the Dutch translation:',
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInputData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.exercise.englishPrompt,
        key: const ValueKey('write_exercise_word'),
        style: TextStyles.exerciseInputDataStyle(context),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEvaluation(BuildContext context) {
    if (_answerState == _AnswerState.pending) {
      return _buildTextField(context);
    }
    return _buildEvaluationResult(context);
  }

  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: TextField(
        key: const ValueKey('write_exercise_text_field'),
        controller: _textController,
        autofocus: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          if (_textController.text.trim().isNotEmpty) _onCheckPressed();
        },
        decoration: InputDecoration(
          hintText: 'Type Dutch translation…',
          border: OutlineInputBorder(
            borderRadius: BorderStyles.defaultBorderRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationResult(BuildContext context) {
    switch (_answerState) {
      case _AnswerState.correct:
        return const ExerciseEvaluation(
          isExerciseAnswered: true,
          isCorrectAnswer: true,
        );
      case _AnswerState.nearCorrect:
        return _buildResultWithCorrection(
          context,
          label: 'Almost!',
          labelColor: Colors.orange,
          correctionPrefix: 'Correct spelling:',
        );
      case _AnswerState.wrong:
        return _buildResultWithCorrection(
          context,
          label: 'Wrong!',
          labelColor: TextStyles.failureTextColor,
          correctionPrefix: 'Answer:',
        );
      case _AnswerState.pending:
        return const SizedBox.shrink();
    }
  }

  /// Renders a two-line result: a coloured [label] on the first line and a
  /// muted [correctionPrefix] + bold-green correct word on the second line.
  Widget _buildResultWithCorrection(
    BuildContext context, {
    required String label,
    required Color labelColor,
    required String correctionPrefix,
  }) {
    final correctWord = widget.exercise.word.dutchWord;
    final mutedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyles.exerciseEvaluationTextStyle.copyWith(
            color: labelColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$correctionPrefix ',
                style: TextStyle(fontSize: 18, color: mutedColor),
              ),
              TextSpan(
                text: correctWord,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TextStyles.successTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (_answerState == _AnswerState.pending) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              key: const ValueKey('write_exercise_check_button'),
              onPressed: _textController.text.trim().isNotEmpty
                  ? _onCheckPressed
                  : null,
              style: ButtonStyles.largeWidePrimaryButtonStyle(context),
              child: const Text('Check'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: widget.onNextButtonPressed,
            style: ButtonStyles.largeWidePrimaryButtonStyle(context),
            child: Text(widget.nextButtonText),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
      contentBuilder: (context) => ExerciseContent(
        promptBuilder: _buildPrompt,
        inputDataBuilder: _buildInputData,
        evaluationBuilder: _buildEvaluation,
      ),
      footerBuilder: _buildFooter,
    );
  }
}
