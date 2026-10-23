import 'package:flutter/material.dart';
import 'widgets/town_member_row.dart';
import 'widgets/game_nav_bar.dart';

// Evidence screen displaying town members without tokens
class EvidenceScreen extends StatelessWidget {
  // List of town member names supplied by the parent
  final List<String> townMembers;

  // Functions supplied by the parent to handle user actions
  final ValueChanged<String> onMemberPressed;
  final VoidCallback onTown;
  final VoidCallback onHelp;

  // Constructor
  const EvidenceScreen({
    super.key,
    required this.townMembers,
    required this.onMemberPressed,
    required this.onTown,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Navigation bar
            GameNavBar(
              selectedTab: GameNavTab.evidence,
              onTown: onTown,
              onEvidence: () {}, // Already on evidence screen
              onHelp: onHelp,
            ),

            // Scrollable list of town members
            Expanded(
              child: ListView.builder(
                itemCount: townMembers.length,

                // Create a new row for each town member
                itemBuilder: (context, index) {
                  final memberName = townMembers[index];

                  return TownMemberRow(
                    memberName: memberName,
                    showToken: false, // Hide tokens on evidence screen
                    onMemberPressed: () {
                      onMemberPressed(memberName);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}