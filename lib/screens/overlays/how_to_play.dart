
import 'package:flutter/material.dart';

// Overlay displaying instructions for playing the game
class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('How to Play'),

      // Large scrollable text area for game instructions
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.45,

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),

          child: const SingleChildScrollView(
            child: Text(
              'Game instructions will be added here.\n\n'
              'This section will explain the rules, '
              'objectives, and mechanics of Bloody Mystery.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),

      // Close the overlay and return to the main menu
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}