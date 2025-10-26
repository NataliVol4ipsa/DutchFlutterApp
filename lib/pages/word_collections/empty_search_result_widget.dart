import 'package:flutter/material.dart';

class EmptySearchResultWidget extends StatelessWidget {
  final String searchTerm;
  final void Function()? onCreatePressed;

  const EmptySearchResultWidget({
    super.key,
    required this.searchTerm,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No results found for "$searchTerm".',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Create "$searchTerm"'),
            onPressed: onCreatePressed,
          ),
          SizedBox(height: 8),
          Text(
            'Word does not exist. You can create a new one.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
