import 'package:dutch_app/pages/learning_session/base/base_session_step_layout_widget.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/notifiers/session_completed_notifier.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary_widget.dart';
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

  Widget _buildExercise(BuildContext context) {
    Key taskKey = UniqueKey();
    return Stack(children: [
      widget.flowManager.currentTask?.buildWidget(
              key: taskKey,
              onNextButtonPressed: _onNextButtonPressedAsync,
              nextButtonText:
                  widget.flowManager.hasNextTask ? "Next" : "Finish") ??
          const Text("Error: the queue is empty"),
      //_buildNextButton(context),
    ]);
  }

  Future<void> _onNextButtonPressedAsync() async {
    _learningTaskAnsweredNotifier?.reset();
    if (widget.flowManager.hasNextTask) {
      setState(() {
        widget.flowManager.moveToNextExercise();
      });
      return;
    }

    await widget.flowManager.processSessionResultsAsync();
    setState(() {
      widget.flowManager.endSession();
    });
    _learningTasksCompletedNotifier?.notifyCompleted();
  }

  //

  Widget _buildSummary(BuildContext context) {
    SessionSummary summary = widget.flowManager.sessionSummary!;

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
    if (widget.flowManager.totalTasks > 0) {
      return 'Exercises remaining: ${widget.flowManager.totalTasks}';
    }
    return "Session complete";
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
