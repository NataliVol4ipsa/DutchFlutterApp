import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';
import 'package:first_project/pages/learning_session/session_manager.dart';
import 'package:first_project/pages/learning_session/session_page.dart';
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

  List<LearningModeType> learningModes = LearningModeType.values.toList();
  final Set<LearningModeType> selectedModes = {};

  @override
  void initState() {
    super.initState();
    wordsRepository = context.read<WordsRepository>();
  }

  void onStartButtonClick() async {
    List<Word> words = await wordsRepository.getAsync();
    // TEMP. REMOVE
    words = [words[0], words[1], words[2]];
    var flowManager = LearningSessionManager(selectedModes.toList(), words);
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
      appBar: AppBar(title: const Text('Select Learning Modes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: learningModes.length,
                itemBuilder: (context, index) {
                  LearningModeType mode = learningModes[index];
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
                            ? colorScheme.primary.withOpacity(0.3)
                            : colorScheme.surface,
                        textColor: isSelected
                            ? colorScheme.onPrimary
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
              child: ElevatedButton(
                onPressed: selectedModes.isNotEmpty
                    ? () {
                        onStartButtonClick();
                      }
                    : null,
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}