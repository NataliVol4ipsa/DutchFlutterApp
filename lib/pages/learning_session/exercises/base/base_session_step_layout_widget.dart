import 'package:flutter/material.dart';

class BaseSessionStepLayout extends StatefulWidget {
  final String appBarText;
  final Widget Function(BuildContext context) contentBuilder;
  final bool enableBackButton;
  // todo disable three android buttons back button too. Or show pop up to confirm

  const BaseSessionStepLayout(
      {required this.appBarText,
      required this.contentBuilder,
      super.key,
      this.enableBackButton = false});

  @override
  State<BaseSessionStepLayout> createState() => _BaseSessionStepLayoutState();
}

class _BaseSessionStepLayoutState extends State<BaseSessionStepLayout> {
  @override
  Widget build(BuildContext context) {
    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarText,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: widget.enableBackButton,
      ),
      body: widget.contentBuilder(context),
    );
  }
}
