import 'package:dutch_app/core/audio/word_audio_service.dart';
import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/notifiers/notifier_tools.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/audio_dictation/audio_dictation_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_content_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

enum _AnswerState { pending, correct, nearCorrect, wrong }

class AudioDictationExerciseWidget extends StatefulWidget {
  final AudioDictationExercise exercise;
  final Future<void> Function() onNextButtonPressed;
  final String nextButtonText;

  const AudioDictationExerciseWidget(
    this.exercise, {
    required this.onNextButtonPressed,
    required this.nextButtonText,
    super.key,
  });

  @override
  State<AudioDictationExerciseWidget> createState() =>
      _AudioDictationExerciseWidgetState();
}

class _AudioDictationExerciseWidgetState
    extends State<AudioDictationExerciseWidget> {
  final TextEditingController _textController = TextEditingController();
  _AnswerState _answerState = _AnswerState.pending;
  bool _hintRevealed = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    // Play the audio automatically as soon as the exercise appears.
    WidgetsBinding.instance.addPostFrameCallback((_) => _playAudio());
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

  void _playAudio() {
    // Eligible words always have cached audio; this never hits the network.
    WordAudioService.playCachedOrUrl(widget.exercise.word.dutchWord);
  }

  void _submit() {
    final correct = widget.exercise.word.dutchWord;
    final result = AudioDictationExercise.evaluateInput(
      _textController.text,
      correct,
    );

    final _AnswerState state;
    final bool isCorrect;
    switch (result) {
      case AudioDictationResult.correct:
        state = _AnswerState.correct;
        isCorrect = true;
        break;
      case AudioDictationResult.nearCorrect:
        state = _AnswerState.nearCorrect;
        isCorrect = true;
        break;
      case AudioDictationResult.wrong:
        state = _AnswerState.wrong;
        isCorrect = false;
        break;
    }

    _finishAnswer(state, isCorrect);
  }

  void _onDontKnow() {
    _finishAnswer(_AnswerState.wrong, false);
  }

  void _finishAnswer(_AnswerState state, bool isCorrect) {
    setState(() => _answerState = state);
    widget.exercise.processAnswer(isCorrect);
    FocusScope.of(context).unfocus();
    notifyAnsweredExercise(context, true);
  }

  Widget _buildPrompt(BuildContext context) {
    return Text(
      'Listen and write the word you hear:',
      style: TextStyles.exercisePromptStyle(context),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInputData(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasHint = widget.exercise.hint != null;
    final canRevealHint =
        hasHint && !_hintRevealed && _answerState == _AnswerState.pending;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const ValueKey('audio_dictation_play_button'),
          iconSize: 48,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.volume_up),
          color: colorScheme.onSurface,
          onPressed: _playAudio,
        ),
        if (hasHint && _hintRevealed)
          Text(
            widget.exercise.hint!,
            key: const ValueKey('audio_dictation_hint_text'),
            style: TextStyles.exerciseInputDataHintStyle(context),
            textAlign: TextAlign.center,
          )
        else if (canRevealHint)
          TextButton.icon(
            key: const ValueKey('audio_dictation_hint_button'),
            onPressed: () => setState(() => _hintRevealed = true),
            icon: const Icon(Icons.lightbulb_outline, size: 16),
            label: const Text('Show part of speech'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              minimumSize: const Size(0, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
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
        key: const ValueKey('audio_dictation_text_field'),
        controller: _textController,
        autofocus: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          if (_textController.text.trim().isNotEmpty) _submit();
        },
        decoration: InputDecoration(
          hintText: 'Type the Dutch word you heard…',
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
        return _buildResultWithCorrection(
          context,
          label: 'Correct!',
          labelColor: TextStyles.successTextColor,
          correctionPrefix: 'Word:',
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

  /// Renders the result block: a coloured status [label], the correct Dutch
  /// word with its [correctionPrefix], and the English translation below.
  Widget _buildResultWithCorrection(
    BuildContext context, {
    required String label,
    required Color labelColor,
    required String correctionPrefix,
  }) {
    final correctWord = widget.exercise.word.dutchWord;
    final englishTranslation = SemicolonWordsConverter.toSingleString(
      widget.exercise.word.englishWords,
    );
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
        if (englishTranslation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            englishTranslation,
            key: const ValueKey('audio_dictation_english_translation'),
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: mutedColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (_answerState != _AnswerState.pending) {
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

    return Row(
      children: [
        Expanded(
          child: TextButton(
            key: const ValueKey('audio_dictation_dont_know_button'),
            onPressed: _onDontKnow,
            style: ButtonStyles.largeWideSecondaryButtonStyle(context),
            child: const Text("Don't know"),
          ),
        ),
        const SizedBox(width: ContainerStyles.defaultPaddingAmount),
        Expanded(
          child: TextButton(
            key: const ValueKey('audio_dictation_submit_button'),
            onPressed: _textController.text.trim().isNotEmpty ? _submit : null,
            style: ButtonStyles.largeWidePrimaryButtonStyle(context),
            child: const Text('Submit'),
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
