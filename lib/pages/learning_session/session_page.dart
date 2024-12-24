import 'package:first_project/pages/learning_session/exercises/base/base_session_step_layout_widget.dart';
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
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.flowManager.hasNextTask ? "Next" : "Finish",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildExercise(BuildContext context) {
    Key taskKey = UniqueKey();
    return Stack(children: [
      widget.flowManager.currentTask.buildWidget(
        key: taskKey,
      ),
      _buildNextButton(context),
    ]);
  }

  Widget _buildSummary(BuildContext context) {
    return Column(
      children: [
        Text('Total exercises: ${widget.flowManager.summary?.totalExercises}'),
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<SessionCompletedNotifier>(
        builder: (context, notifier, child) {
      bool showSessionTasks = !notifier.isCompleted;
      if (showSessionTasks) {
        return _buildExercise(context);
      } else {
        return _buildSummary(context);
      }
    });
  }

  String _buildAppBarText() {
    return 'Task ${widget.flowManager.currentExerciseIndex + 1} of ${widget.flowManager.totalTasks}';
  }

  @override
  Widget build(BuildContext context) {
    return BaseSessionStepLayout(
      appBarText: _buildAppBarText(),
      contentBuilder: _buildContent,
      enableBackButton: true, //todo
    );
  }
}

// Widget buildOld(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(
//           'Task ${widget.flowManager.currentExerciseIndex + 1} of ${widget.flowManager.totalTasks}'),
//     ),
//     body: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildContent(context),
//           ),
//         ),
//         Container(
//           color: Colors.grey.shade200,
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.home),
//                 label: Text('Home'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.search),
//                 label: Text('Search'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.settings),
//                 label: Text('Settings'),
//               ),
//             ],
//           ),
//         ),
//         // Expanded(
//         //   child: widget.flowManager.currentTask.buildWidget(key: taskKey),
//         // ),
//         // Expanded(
//         //   child: _buildNextButton(context),
//         // ),
//       ],
//     ),
//   );
// }
//}
