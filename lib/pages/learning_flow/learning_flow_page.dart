import 'package:first_project/pages/learning_flow/learning_flow_manager.dart';
import 'package:first_project/pages/learning_flow/learning_task_answered_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningFlowPage extends StatefulWidget {
  final LearningFlowManager flowManager;

  const LearningFlowPage({super.key, required this.flowManager});

  @override
  State<LearningFlowPage> createState() => _LearningFlowPageState();
}

class _LearningFlowPageState extends State<LearningFlowPage> {
  bool showNextButton = false;

  @override
  Widget build(BuildContext context) {
    Key taskKey = UniqueKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Task ${widget.flowManager.currentTaskIndex + 1} of ${widget.flowManager.totalTasks}'),
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

  Widget _buildNextButton(BuildContext context) {
    return Consumer<LearningTaskAnsweredNotifier>(
      builder: (context, taskNotifier, child) {
        bool showNextButton =
            taskNotifier.isAnswered && widget.flowManager.hasNextTask;
        return showNextButton
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget.flowManager.hasNextTask) {
                          Provider.of<LearningTaskAnsweredNotifier>(context,
                                  listen: false)
                              .updateAnswer(false);
                          widget.flowManager.moveToNextTask();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
