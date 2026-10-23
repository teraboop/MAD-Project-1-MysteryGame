import 'package:flutter/material.dart';
import 'widgets/game_nav_bar.dart';
import 'widgets/town_member_row.dart';

// Town screen displaying the town and its members
class TownScreen extends StatelessWidget {
  // List of town member names supplied by the parent
  final List<String> townMembers;

  // Functions supplied by the parent to handle user actions
  final ValueChanged<String> onMemberPressed;
  final VoidCallback onEvidence;
  final VoidCallback onHelp;

  // Constructor
  const TownScreen({
    super.key,
    required this.townMembers,
    required this.onMemberPressed,
    required this.onEvidence,
    required this.onHelp,
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

            // Scrollable list of town members
            Expanded(
              child: ListView.builder(
                itemCount: townMembers.length,

                // Create a row for each town member
                itemBuilder: (context, index) {
                  final memberName = townMembers[index];

                  return TownMemberRow(
                    memberName: memberName,
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