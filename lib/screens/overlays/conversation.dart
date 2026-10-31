import 'package:flutter/material.dart';
import '../widgets/game_button.dart';

// Read-only overlay: shows what a town member (or the narrator) tells the player
class ConversationDialog extends StatelessWidget {
  final String memberName;
  final String text;

  const ConversationDialog({
    super.key,
    required this.memberName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(memberName),
      content: SizedBox(
        width: 440,
        child: Container(
          constraints: const BoxConstraints(minHeight: 120, maxHeight: 260),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(child: Text(text)),
        ),
      ),
      actions: [
        GameButton(
          text: 'Close',
          width: 120,
          height: 44,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
