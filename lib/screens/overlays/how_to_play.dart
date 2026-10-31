
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
              'You are the Investigator. A murderer is hiding in town, '
              'and you must find and execute the Possessed before the '
              'town is wiped out.\n\n'
              'Each day:\n'
              '1. Morning: you are told what happened overnight.\n'
              '2. Conversations: tap any living townsperson to hear what '
              'they have to say. You can talk to anyone as often as you '
              'like. Everything you hear is saved under the Evidence tab.\n'
              '3. Vote: when you are ready, press "Go to the vote" and '
              'choose one person to execute.\n'
              '4. Night: the killer strikes again, and the next morning '
              'begins.\n\n'
              'Watch the role tag beside each name, but remember that '
              'evil characters can lie about what they are.\n\n'
              'Win by executing the Possessed. You lose if the Possessed '
              'is still alive when fewer than 3 people remain.',
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