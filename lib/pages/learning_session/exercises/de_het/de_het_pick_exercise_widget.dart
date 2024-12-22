import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/pages/learning_session/notifiers/notifier_tools.dart';
import 'package:flutter/material.dart';

class DeHetPickExerciseWidget extends StatefulWidget {
  final DeHetPickExercise exercise;
  final String dutchWord;

  const DeHetPickExerciseWidget(this.exercise, this.dutchWord, {super.key});

  @override
  State<DeHetPickExerciseWidget> createState() =>
      _DeHetPickExerciseWidgetState();
}

class _DeHetPickExerciseWidgetState extends State<DeHetPickExerciseWidget> {
  bool? isCorrectAnswer;

  void onAnswerProvided(DeHetType answer) {
    setState(() {
      isCorrectAnswer = widget.exercise.isCorrectAnswer(answer);
    });
    notifyAnsweredExercise(context, true);
    widget.exercise.processAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Select 'De' or 'Het' for the following word:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              widget.dutchWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            if (isCorrectAnswer != null) ...{
              if (isCorrectAnswer == true) ...{
                const Text(
                  "Correct!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              },
              if (isCorrectAnswer == false) ...{
                const Text(
                  "Wrong!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              },
            } else
              const Text(
                " ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            if (isCorrectAnswer == null) ...{
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onAnswerProvided(DeHetType.de);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "De",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onAnswerProvided(DeHetType.het);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Het",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            },
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
