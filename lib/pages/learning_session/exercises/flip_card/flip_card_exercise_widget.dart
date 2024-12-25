import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:first_project/pages/learning_session/notifiers/notifier_tools.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class FlipCardExerciseWidget extends StatefulWidget {
  final FlipCardExercise exercise;

  const FlipCardExerciseWidget(this.exercise, {super.key});

  @override
  State<FlipCardExerciseWidget> createState() => _FlipCardExerciseWidgetState();
}

class _FlipCardExerciseWidgetState extends State<FlipCardExerciseWidget> {
  bool? isCorrectAnswer;

  void onAnswerProvided(bool userKnowsWord) {
    setState(() {
      isCorrectAnswer = userKnowsWord;
    });
    notifyAnsweredExercise(context, true);
    widget.exercise.processAnswer(userKnowsWord);
  }

// @override
//   Widget build(BuildContext context){

//      return BaseExerciseLayout(
//         contentBuilder: _buildContent, footerBuilder: _buildFooter);
//   }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ContainerStyles.containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Do you know the translation of following word?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              widget.exercise.inputWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (widget.exercise.hint != null) ...{
              Text(
                widget.exercise.hint!,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              )
            },
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onAnswerProvided(true);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Know",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onAnswerProvided(false);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Don't know",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            if (isCorrectAnswer != null) ...{
              if (isCorrectAnswer == true) ...{
                const Text(
                  "Good job!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              },
              if (isCorrectAnswer == false) ...{
                const Text(
                  "This word will be shown again later.",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              },
            },
          ],
        ),
      ),
    );
  }
}
