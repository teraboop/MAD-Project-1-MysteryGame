
import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'screens/town.dart';
import 'screens/evidence.dart';
import 'screens/help.dart';
import 'screens/overlays/conversation.dart';
import 'screens/widgets/game_nav_bar.dart';
import 'screens/overlays/how_to_play.dart';
import 'engine/game_engine.dart';
import 'models/character.dart';
import 'models/game_state.dart';
import 'data/role_definitions.dart' as roles;   // prefix: Alignment clashes with Flutter's


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

          onHowToPlay: () {
            showDialog<void>(
              context: context,
              builder: (dialogContext) => const HowToPlayDialog(),
            );
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

  late final GameEngine engine;
  int _shownEvents = 0;

  @override
  void initState() {
    super.initState();
    engine = GameEngine()..newGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNewEvents());
  }

  List<Character> get _npcs =>
      engine.gameState.characters.where((c) => !c.isHuman).toList();
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

  void _showText(String title, String text) {
    showDialog<void>(
      context: context,
      builder: (_) => ConversationDialog(memberName: title, text: text),
    );
  }

  // Shows anything added to publicEvents since the last call (intro, deaths).
  void _showNewEvents() {
    final events = engine.gameState.publicEvents;
    if (events.length > _shownEvents) {
      _showText('Morning', events.sublist(_shownEvents).join('\n\n'));
      _shownEvents = events.length;
    }
  }

  void _afterAction() {
    setState(() {});
    _showNewEvents();
    if (engine.gameState.currentPhase == DayPhase.gameOver) _showEnding();
  }

  void _showEnding() {
    final good = engine.gameState.winner == roles.Alignment.Good;
    _showText(good ? 'Justice' : 'Defeat', good ? goodEnding : evilEnding);
  }

  @override
  Widget build(BuildContext context) {
    // Keep all three screens inside a single game route
    return IndexedStack(
      index: selectedTab.index,
      children: [
        // Town Screen
        TownScreen(
          members: _npcs,
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
          members: _npcs,
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