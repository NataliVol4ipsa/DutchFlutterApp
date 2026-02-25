import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/anki_flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class AnkiFlipCardExerciseWidget extends StatefulWidget {
  final AnkiFlipCardExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const AnkiFlipCardExerciseWidget(
    this.exercise, {
    required this.onNextButtonPressed,
    required this.nextButtonText,
    super.key,
  });

  @override
  State<AnkiFlipCardExerciseWidget> createState() =>
      _AnkiFlipCardExerciseWidgetState();
}

class _AnkiFlipCardExerciseWidgetState
    extends State<AnkiFlipCardExerciseWidget> {
  bool showTranslation = false;

  Future<void> _onGradeSelected(AnkiGrade grade) async {
    widget.exercise.processAnswer(grade);
    notifyAnsweredExercise(context, true);
    await widget.onNextButtonPressed();
  }

  void _onShowTranslationClicked() {
    setState(() {
      showTranslation = true;
    });
  }

  Widget _buildContent(BuildContext context) {
    return ExerciseContent(
      promptBuilder: _buildPrompt,
      inputDataBuilder: _buildInputData,
      evaluationBuilder: (_) => Container(),
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
            if (widget.exercise.hint != null)
              Text(
                widget.exercise.hint!,
                style: TextStyles.exerciseInputDataHintStyle(context),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        Opacity(
          opacity: showTranslation ? 1.0 : 0.0,
          child: Text(
            SemicolonWordsConverter.toSingleString(
              widget.exercise.word.englishWords,
            ),
            style: TextStyles.exerciseInputDataAnswerStyle(context),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return showTranslation
        ? _buildAnkiGradesFooter(context)
        : _buildShowTranslationFooter(context);
  }

  Widget _buildShowTranslationFooter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _onShowTranslationClicked,
            style: ButtonStyles.largeWidePrimaryButtonStyle(context),
            child: const Text("Show translation"),
          ),
        ),
      ],
    );
  }

  Widget _buildAnkiGradesFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: AnkiGrade.values
          .map(
            (grade) => Expanded(
              child: Padding(
                // small gap between buttons
                padding: EdgeInsets.symmetric(
                  horizontal: ContainerStyles.defaultPaddingAmount / 8,
                ),
                child: _buildGradeButton(context, grade),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGradeButton(BuildContext context, AnkiGrade grade) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface = cs.surface;

    Color bgColor;
    Color fgColor;

    switch (grade) {
      case AnkiGrade.again:
        bgColor = Color.alphaBlend(
          Colors.red.withValues(alpha: isDark ? 0.35 : 0.25),
          surface,
        );
        fgColor = isDark ? Colors.red.shade200 : Colors.red.shade900;
        break;
      case AnkiGrade.hard:
        bgColor = Color.alphaBlend(
          Colors.amber.withValues(alpha: isDark ? 0.35 : 0.25),
          surface,
        );
        fgColor = isDark ? Colors.amber.shade200 : Colors.amber.shade900;
        break;
      case AnkiGrade.good:
        bgColor = Color.alphaBlend(
          Colors.green.withValues(alpha: isDark ? 0.35 : 0.25),
          surface,
        );
        fgColor = isDark ? Colors.green.shade200 : Colors.green.shade900;
        break;
      case AnkiGrade.easy:
        bgColor = Color.alphaBlend(
          Colors.blue.withValues(alpha: isDark ? 0.35 : 0.25),
          surface,
        );
        fgColor = isDark ? Colors.blue.shade200 : Colors.blue.shade900;
        break;
    }

    return TextButton(
      onPressed: () => _onGradeSelected(grade),
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(0, 52),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            grade.reviewHint,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: fgColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            grade.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
