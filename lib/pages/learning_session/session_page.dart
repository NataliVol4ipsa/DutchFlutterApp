import 'package:first_project/pages/learning_session/exercises/base/base_session_step_layout_widget.dart';
import 'package:first_project/pages/learning_session/layered_bottom_widget.dart';
import 'package:first_project/pages/learning_session/session_manager.dart';
import 'package:first_project/pages/learning_session/notifiers/exercise_answered_notifier.dart';
import 'package:first_project/pages/learning_session/notifiers/session_completed_notifier.dart';
import 'package:first_project/pages/learning_session/session_summary_widget.dart';
import 'package:first_project/styles/button_styles.dart';
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
            ? LayeredBottom(contentBuilder: (context) {
                return ElevatedButton(
                  onPressed: _onNextButtonPressedAsync,
                  style: ButtonStyles.primaryButtonStyle,
                  child:
                      Text(widget.flowManager.hasNextTask ? "Next" : "Finish"),
                );
              })
            : Container();
      },
    );
  }

  Future<void> _onNextButtonPressedAsync() async {
    _learningTaskAnsweredNotifier?.notifyAnswerUpdated(false);
    if (widget.flowManager.hasNextTask) {
      setState(() {
        widget.flowManager.moveToNextExercise();
      });
      return;
    }

    await widget.flowManager.processSessionResultsAsync();
    _learningTasksCompletedNotifier?.notifyCompleted();
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
    SessionSummary summary = widget.flowManager.summary!;

    return SessionSummaryWidget(summary: summary);
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
