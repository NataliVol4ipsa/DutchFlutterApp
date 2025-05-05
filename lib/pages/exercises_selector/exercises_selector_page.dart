import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/services/practice_session_stateful_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/pages/learning_session/session_page.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesSelectorPage extends StatefulWidget {
  const ExercisesSelectorPage({super.key});

  @override
  State<ExercisesSelectorPage> createState() => _ExercisesSelectorPageState();
}

Widget customPadding() => const SizedBox(height: 10);

class _ExercisesSelectorPageState extends State<ExercisesSelectorPage> {
  late WordsRepository wordsRepository;

  List<ExerciseType> learningModes = ExerciseType.values.toList();
  final Set<ExerciseType> selectedModes = {};

  @override
  void initState() {
    super.initState();
    wordsRepository = context.read<WordsRepository>();
  }

  void onStartButtonClick() {
    var service = context.read<PracticeSessionStatefulService>();
    List<Word> words = service.words;
    var wordProgressRepository =
        Provider.of<WordProgressRepository>(context, listen: false);
    var notifier =
        Provider.of<ExerciseAnsweredNotifier>(context, listen: false);
    var flowManager = LearningSessionManager(
        selectedModes.toList(), words, wordProgressRepository, notifier);
    if (!mounted) return;
    navigateToLearningTaskPage(context, flowManager);
  }

  void navigateToLearningTaskPage(
      BuildContext context, LearningSessionManager flowManager) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningSessionPage(flowManager: flowManager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: Text('Select Learning Modes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: learningModes.length,
                itemBuilder: (context, index) {
                  ExerciseType mode = learningModes[index];
                  bool isSelected = selectedModes.contains(mode);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(mode.label),
                        subtitle: Text(
                          mode.explanation,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        tileColor: isSelected
                            ? colorScheme.secondaryContainer
                            : colorScheme.surface,
                        textColor: isSelected
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurface,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedModes.remove(mode);
                            } else {
                              selectedModes.add(mode);
                            }
                          });
                        },
                      ),
                      customPadding(),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: selectedModes.isNotEmpty
                          ? () {
                              onStartButtonClick();
                            }
                          : null,
                      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
                      child: const Text('Start'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
