import 'package:flutter/material.dart';

class Tip extends StatelessWidget {
  const Tip({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.teal),
          const SizedBox(width: 8),
          const Text('Tip'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.teal,),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
      content: Text(content)
    );
  }
}
