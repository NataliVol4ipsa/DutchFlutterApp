import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:flutter/material.dart';

class BaseSessionStepLayout extends StatefulWidget {
  final String appBarText;
  final Widget Function(BuildContext context) contentBuilder;
  final bool enableBackButton;
  final VoidCallback? onBackPressed;
  final bool isSessionOver;
  final Widget? progressBar;

  const BaseSessionStepLayout({
    required this.appBarText,
    required this.contentBuilder,
    super.key,
    this.enableBackButton = false,
    this.onBackPressed,
    this.isSessionOver = false,
    this.progressBar,
  });

  @override
  State<BaseSessionStepLayout> createState() => _BaseSessionStepLayoutState();
}

class _BaseSessionStepLayoutState extends State<BaseSessionStepLayout> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isSessionOver || widget.onBackPressed == null,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && widget.onBackPressed != null && !widget.isSessionOver) {
          widget.onBackPressed!();
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(widget.appBarText, textAlign: TextAlign.center),
          centerTitle: true,
          automaticallyImplyLeading: widget.enableBackButton,
          leading: widget.enableBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBackPressed,
                )
              : null,
        ),
        body: widget.progressBar != null
            ? Column(
                children: [
                  widget.progressBar!,
                  Expanded(child: widget.contentBuilder(context)),
                ],
              )
            : widget.contentBuilder(context),
      ),
    );
  }
}
