import 'package:flutter/material.dart';

class DeleteWordDialog extends StatelessWidget {
  final Function onDeletePressed;

  const DeleteWordDialog({
    super.key,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete following items?'),
      content: const Text('This action is permanent.'),
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
