
import 'package:flutter/material.dart';
import '../widgets/game_button.dart';

// Represents a question and its corresponding response
class ConversationChoice {
  final String question;
  final String response;

  // Constructor
  const ConversationChoice({
    required this.question,
    required this.response,
  });
}

// Reusable conversation overlay
class ConversationDialog extends StatefulWidget {
  // Information supplied by the parent
  final String memberName;
  final List<ConversationChoice> choices;

  // Constructor
  const ConversationDialog({
    super.key,
    required this.memberName,
    required this.choices,
  });

  @override
  State<ConversationDialog> createState() =>
      _ConversationDialogState();
}

// Manages the currently selected question
class _ConversationDialogState extends State<ConversationDialog> {
  // Null means no question has been selected
  int? selectedQuestionIndex;

  @override
  Widget build(BuildContext context) {

    // Determine which conversation text to display
    final conversationText = selectedQuestionIndex == null
        ? 'What would you like to ask ${widget.memberName}?'
        : '${widget.choices[selectedQuestionIndex!].question}\n\n'
          '${widget.memberName}: '
          '${widget.choices[selectedQuestionIndex!].response}';

    return AlertDialog(
      // Display the town member's name and a close button
      title: Row(
        children: [
          Expanded(
            child: Text(widget.memberName),
          ),

          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      // Main conversation content
      content: SingleChildScrollView(
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Large box displaying the conversation
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),

                // Allow longer conversations to scroll
                child: SingleChildScrollView(
                  child: Text(conversationText),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Ask a question:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Generate a button for each available question
              for (int i = 0; i < widget.choices.length; i++) ...[
                GameButton(
                  text: widget.choices[i].question,
                  height: 56,
                  fontSize: 14,
                  onPressed: () {
                    setState(() {
                      selectedQuestionIndex = i;
                    });
                  },
                ),

                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
