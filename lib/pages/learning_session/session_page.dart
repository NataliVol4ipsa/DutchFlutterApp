import 'package:first_project/pages/learning_session/session_manager.dart';
import 'package:first_project/pages/learning_session/notifiers/exercise_answered_notifier.dart';
import 'package:first_project/pages/learning_session/notifiers/session_completed_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Page that renders all tasks of current session
class LearningSessionPage extends StatefulWidget {
  final LearningSessionManager flowManager;

  const LearningSessionPage({super.key, required this.flowManager});

  @override
  State<LearningSessionPage> createState() => _LearningSessionPageState();
}

class _LearningSessionPageState extends State<LearningSessionPage> {
  bool showNextButton = false;
  ExerciseAnsweredNotifier? _learningTaskAnsweredNotifier;
  SessionCompletedNotifier? _learningTasksCompletedNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capture the references to the notifiers for future disposal
    _learningTaskAnsweredNotifier ??=
        Provider.of<ExerciseAnsweredNotifier>(context, listen: false);
    _learningTasksCompletedNotifier ??=
        Provider.of<SessionCompletedNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _learningTaskAnsweredNotifier?.reset();
    _learningTasksCompletedNotifier?.reset();
    super.dispose();
  }

  Widget _buildNextButton(BuildContext context) {
    return Consumer<ExerciseAnsweredNotifier>(
      builder: (context, taskNotifier, child) {
        bool showNextButton = taskNotifier.isAnswered;
        return showNextButton
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _learningTaskAnsweredNotifier
                            ?.notifyAnswerUpdated(false);
                        if (widget.flowManager.hasNextTask) {
                          widget.flowManager.moveToNextExercise();
                        } else {
                          widget.flowManager.generateSummary();
                          _learningTasksCompletedNotifier?.notifyCompleted();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.flowManager.hasNextTask ? "Next" : "Finish",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildTask(BuildContext context) {
    Key taskKey = UniqueKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Task ${widget.flowManager.currentExerciseIndex + 1} of ${widget.flowManager.totalTasks}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: widget.flowManager.currentTask.buildWidget(key: taskKey),
            ),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                'Total exercises: ${widget.flowManager.summary?.totalExercises}'),
            Text(
                'Correct answers: ${widget.flowManager.summary?.correctExercises} (${widget.flowManager.summary?.correctPercent.toStringAsFixed(2)}%)'),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Back to menu",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionCompletedNotifier>(
        builder: (context, notifier, child) {
      bool showSessionTasks = !notifier.isCompleted;
      if (showSessionTasks) {
        return _buildTask(context);
      } else {
        return _buildSummary(context);
      }
    });
  }
}
