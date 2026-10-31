import 'package:flutter/material.dart';
import '../widgets/game_button.dart';

class ConversationDialog extends StatelessWidget {
  final String memberName;
  final String text;

  const ConversationDialog({super.key, required this.memberName, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(memberName),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(child: Text(text)),
      ),
      actions: [
        GameButton(text: 'Close', width: 120, onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}