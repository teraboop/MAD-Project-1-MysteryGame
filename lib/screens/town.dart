import 'package:flutter/material.dart';
import 'widgets/game_nav_bar.dart';
import 'widgets/town_member_row.dart';
import '../models/character.dart';
import 'widgets/game_button.dart';

// Town screen displaying the town and its members
class TownScreen extends StatelessWidget {
  // List of town members supplied by the parent
  final List<Character> members;

  // Functions supplied by the parent to handle user actions
  final ValueChanged<Character> onMemberPressed;
  final VoidCallback onEvidence;
  final VoidCallback onHelp;

  final String statusText;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String Function(Character)? claimFor;

  // Constructor
  const TownScreen({
    super.key,
    this.claimFor,
    required this.members,
    required this.onMemberPressed,
    required this.onEvidence,
    required this.onHelp,
    required this.statusText,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main content of the screen
      body: SafeArea(
        child: Column(
          children: [
            // Navigation bar at the top
            GameNavBar(
              selectedTab: GameNavTab.town,
              onTown: () {}, // Already on the town screen
              onEvidence: onEvidence,
              onHelp: onHelp,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                statusText,
              )
            ),
            // Scrollable list of town members
            Expanded(
              child: ListView.builder(
                itemCount: members.length,

                // Create a row for each town member
                itemBuilder: (context, index) {
                  final m = members[index];

                  return TownMemberRow(
                    memberName: m.name,
                    tokenLabel: m.isAlive ? (claimFor?.call(m) ?? '?') : 'Dead',
                    onMemberPressed: () {
                      onMemberPressed(m);
                    },
                  );
                },
              ),
            ),
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GameButton(text: actionLabel!, onPressed: onAction),
                )
          ],
        ),
      ),
    );
  }
}