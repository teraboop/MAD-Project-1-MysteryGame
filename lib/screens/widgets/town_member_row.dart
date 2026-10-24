import 'package:flutter/material.dart';
import 'game_button.dart';

// Reusable row representing a town member
class TownMemberRow extends StatelessWidget {
  // Info displayed in the row
  final String memberName;
  final String tokenLabel;

  // Function supplied by the parent when a member is selected
  final VoidCallback onMemberPressed;

  // Constructor
  const TownMemberRow({
    super.key,
    required this.memberName,
    required this.onMemberPressed,
    this.tokenLabel = '?',
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve app color scheme
    final colors = Theme.of(context).colorScheme;

    return Padding(
      // Space around each row
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      // Arrange the member button and token horizontally
      child: Row(
        children: [
          // Town member button
          Expanded(
            child: GameButton(
              text: memberName,
              height: 48,
              fontSize: 16,
              onPressed: onMemberPressed,
            ),
          ),

          // Space between button and token
          const SizedBox(width: 12),

          // Visual placeholder for the member's token
          Container(
            width: 70,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tokenLabel,
              style: TextStyle(
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}