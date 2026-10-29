
import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'screens/town.dart';
import 'screens/evidence.dart';
import 'screens/help.dart';
import 'screens/overlays/conversation.dart';
import 'screens/widgets/game_nav_bar.dart';

// Temporary town member names until the game engine is implemented
const List<String> townMembers = [
  'Town Member 1',
  'Town Member 2',
  'Town Member 3',
  'Town Member 4',
  'Town Member 5',
  'Town Member 6',
  'Town Member 7',
  'Town Member 8',
];

void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloody Mystery',
      debugShowCheckedModeBanner: false,

      // Application color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
      ),

      // Display the main menu when the app starts
      home: Builder(
        builder: (context) => MenuScreen(
          onPlay: () {
            // Enter the game as a single route
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GameShell(),
              ),
            );
          },

          // Disabled until save functionality is implemented
          onContinue: null,

          onOptions: () {
            debugPrint('Options pressed');
          },

          onCredits: () {
            debugPrint('Credits pressed');
          },
        ),
      ),
    );
  }
}

// Manages navigation between the game's main screens
class GameShell extends StatefulWidget {
  const GameShell({super.key});

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  // Currently selected game tab
  GameNavTab selectedTab = GameNavTab.town;

  // Switch screens without adding routes to the navigator
  void selectTab(GameNavTab tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  // Open the conversation overlay for a town member
  void openConversation(String name) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ConversationDialog(
        memberName: name,

        // Temporary questions and responses
        choices: const [
          ConversationChoice(
            question: 'Where were you last night?',
            response: 'I was at home all evening.',
          ),

          ConversationChoice(
            question: 'Who do you suspect?',
            response: 'I do not trust the innkeeper.',
          ),

          ConversationChoice(
            question: 'What do you know about the demon?',
            response: 'Only that it is hiding among us.',
          ),
        ],
      ),
    );
  }

  // Temporary placeholder for town member evidence
  void openMemberEvidence(String name) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(name),
        content: const Text(
          'Evidence for this town member will appear here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep all three screens inside a single game route
    return IndexedStack(
      index: selectedTab.index,
      children: [
        // Town Screen
        TownScreen(
          townMembers: townMembers,
          onMemberPressed: openConversation,

          onEvidence: () {
            selectTab(GameNavTab.evidence);
          },

          onHelp: () {
            selectTab(GameNavTab.help);
          },
        ),

        // Evidence Screen
        EvidenceScreen(
          townMembers: townMembers,
          onMemberPressed: openMemberEvidence,

          onTown: () {
            selectTab(GameNavTab.town);
          },

          onHelp: () {
            selectTab(GameNavTab.help);
          },
        ),

        // Help Screen
        HelpScreen(
          onTown: () {
            selectTab(GameNavTab.town);
          },

          onEvidence: () {
            selectTab(GameNavTab.evidence);
          },
        ),
      ],
    );
  }
}