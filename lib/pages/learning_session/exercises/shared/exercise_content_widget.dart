import 'package:flutter/material.dart';

class ExerciseContent extends StatelessWidget {
  final Widget Function(BuildContext context) promptBuilder;
  final Widget Function(BuildContext context) inputDataBuilder;
  final Widget Function(BuildContext context) evaluationBuilder;

  const ExerciseContent(
      {super.key,
      required this.promptBuilder,
      required this.inputDataBuilder,
      required this.evaluationBuilder});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var questionBackgroundColor = colorScheme.surfaceContainerHighest;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: promptBuilder(context),
            )),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: questionBackgroundColor,
            ),
            alignment: Alignment.center,
            child: inputDataBuilder(context),
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: evaluationBuilder(context),
            )),
      ],
    );
  }
}
