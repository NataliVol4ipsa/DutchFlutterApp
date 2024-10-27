import 'package:first_project/core/business_logic/learning_modes/learning_modes_tasks/de_het_pick_learning_mode_task.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/pages/learning/learning_flow/learning_task_answered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeHetPickLearningTaskWidget extends StatefulWidget {
  final DeHetPickLearningModeTask task;
  final String dutchWord;

  const DeHetPickLearningTaskWidget(this.task, this.dutchWord, {super.key});

  @override
  State<DeHetPickLearningTaskWidget> createState() =>
      _DeHetPickLearningTaskWidgetState();
}

class _DeHetPickLearningTaskWidgetState
    extends State<DeHetPickLearningTaskWidget> {
  late bool? isCorrectAnswer = null;

  void onAnswerProvided(DeHetType answer) {
    setState(() {
      isCorrectAnswer = widget.task.isCorrectAnswer(answer);
    });
    Provider.of<LearningTaskAnsweredNotifier>(context, listen: false)
        .updateAnswer(true);
    widget.task.processAnswer(answer);
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
            const SizedBox(height: 30),
            Text(
              widget.dutchWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 40),
            if (isCorrectAnswer != null) ...{
              if (isCorrectAnswer! == true) ...{
                const Text(
                  "Correct!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              },
              if (isCorrectAnswer! == false) ...{
                const Text(
                  "Wrong!",
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
