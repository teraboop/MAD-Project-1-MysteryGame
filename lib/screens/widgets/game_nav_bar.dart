import 'package:flutter/material.dart';
import 'game_button.dart';

// Reusable navigation bar for the games main screens
class GameNavBar extends StatelessWidget {
  // Indicates which screen is currently selected
  final GameNavTab selectedTab;

  // Functions supplied by the parent to handle navigation
  final VoidCallback onTown;
  final VoidCallback onEvidence;
  final VoidCallback onHelp;

  // Constructor
  const GameNavBar({
    super.key,
    required this.selectedTab,
    required this.onTown,
    required this.onEvidence,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Space around the nav bar
      padding: const EdgeInsets.all(12),

      // Arrange the buttons horizontally
      child: Row(
        children: [
          // Town button
          Expanded(
            child: GameButton(
              text: 'Town',
              height: 45,
              fontSize: 14,
              variant: selectedTab == GameNavTab.town
                ? GameButtonVariant.primary
                : GameButtonVariant.secondary,
              onPressed: onTown,
            ),
          ),

          const SizedBox(width: 8),

          // Evidence button
          Expanded(
            child: GameButton(
              text: 'Evidence',
              height: 45,
              fontSize: 14,
              variant: selectedTab == GameNavTab.evidence
                ? GameButtonVariant.primary
                : GameButtonVariant.secondary,
              onPressed: onEvidence,
            ),
          ),

          const SizedBox(width: 8),

          // Help button
          Expanded(
            child: GameButton(
              text: 'Help',
              height: 45,
              fontSize: 14,
              variant: selectedTab == GameNavTab.help
                ? GameButtonVariant.primary
                : GameButtonVariant.secondary,
              onPressed: onHelp,
            ),
          ),
        ]
      )
    );
  }
}

// Available navigation destinations
enum GameNavTab {
  town,
  evidence,
  help,
}