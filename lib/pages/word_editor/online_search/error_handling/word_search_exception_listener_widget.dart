import 'package:dutch_app/domain/notifiers/online_word_search_error_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordSearchExceptionListener extends StatelessWidget {
  const WordSearchExceptionListener({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlineWordSearchErrorNotifier>(
        builder: (context, notifier, child) {
      if (notifier.hasError) {
        if (kDebugMode) {
          return SelectableText(
              "Error: [${notifier.errorStatusCode}]. '${notifier.errorMesssage}'");
        }
        return Text(
            "Failed to access online word search service. Please check app permissions or try again later.");
      }
      return Container();
    });
  }
}
