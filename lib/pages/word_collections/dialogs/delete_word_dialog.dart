import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class DeleteWordDialog extends StatelessWidget {
  final Function onDeletePressed;
  final String? additionalText;

  const DeleteWordDialog({
    super.key,
    required this.onDeletePressed,
    this.additionalText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete following items?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (additionalText != null)
            Text(
              additionalText!,
              style: TextStyles.modalDescriptionTextStyle,
            ),
          Text(
            'This action is permanent.',
            style: TextStyles.modalDescriptionTextStyle,
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            const SizedBox(
              height: 30,
              child: VerticalDivider(thickness: 1, color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDeletePressed();
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
