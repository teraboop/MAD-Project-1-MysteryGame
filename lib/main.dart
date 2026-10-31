
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/menu.dart';
import 'screens/town.dart';
import 'screens/evidence.dart';
import 'screens/help.dart';
import 'screens/overlays/conversation.dart';
import 'screens/widgets/game_nav_bar.dart';
import 'screens/overlays/how_to_play.dart';
import 'engine/game_engine.dart';
import 'database/game_persistence.dart';
import 'models/character.dart';
import 'models/game_state.dart';
import 'data/role_definitions.dart' as roles;   // prefix: Alignment clashes with Flutter's
import 'data/scenarios.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sqflite needs the FFI factory on desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
  final GamePersistence _store = GamePersistence();
  int _shownEvents = 0;

  @override
  void initState() {
    super.initState();
    engine = GameEngine()..newGame();
    _store.startNewGame(engine.scenario);
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

  String? get _actionLabel {
    final g = engine.gameState;
    switch (g.currentPhase) {
      case DayPhase.morning:       return 'Start the day';
      case DayPhase.conversations: return 'Go to the vote';
      case DayPhase.voting:        return null;
      default:                     return null;
    }
  }

  void _advance() {
    engine.advancePhase();
    _afterAction();
  }

  String get _status {
    final g = engine.gameState;
    final hint = switch (g.currentPhase) {
      DayPhase.morning => 'Start the day when you are ready',
      DayPhase.conversations => 'Talk to someone · Conversations left: ${g.conversationsLeft}',
      DayPhase.voting => 'Tap someone to execute them',
      _ => '',
    };
    return 'Day ${g.day}\n$hint';
  }

  void onMemberPressed(Character c) {
    final g = engine.gameState;
    if (g.currentPhase == DayPhase.gameOver) return;
    if (!c.isAlive) {
      _snack('${c.name} is dead.');
      return;
    }

    if (g.currentPhase == DayPhase.conversations) {
      try {
        final before = g.conversationsLeft;
        final line = engine.talkTo(c.id);
        if (g.conversationsLeft < before) {
          _store.recordHeard(c.id, g.day, line);
          _store.saveProgress(g);
        }
        setState(() {});
        _showText(c.name, line.text);
      } on StateError catch (e) {
        _snack(e.message);
      }
    } else if (g.currentPhase == DayPhase.voting) {
      _confirmExecute(c);
    } else {
      _snack('You can only talk during the conversation phase.');
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _confirmExecute(Character c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('Execute ${c.name}?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(d, true), child: const Text('Execute')),
        ],
      ),
    );
    if (ok != true) return;
    engine.executeCharacter(c.id);
    if (engine.gameState.currentPhase != DayPhase.gameOver) engine.advancePhase(); // run the night
    _afterAction();
  }

  // Evidence for a town member, read back from the database
  Future<void> openMemberEvidence(String name) async {
    final c = _npcs.firstWhere((c) => c.name == name);
    final stored = await _store.evidenceFor(c.id);
    final lines = stored ?? engine.gameState.heard[c.id] ?? [];
    if (!mounted) return;
    _showText(name, lines.isEmpty ? 'You have not spoken to $name yet.' : lines.join('\n\n'));
  }

  Future<void> _showText(String title, String text) {
    return showDialog<void>(
      context: context,
      builder: (_) => ConversationDialog(memberName: title, text: text),
    );
  }

  // Shows anything added to publicEvents since the last call (intro, deaths).
  Future<void> _showNewEvents() async {
    final events = engine.gameState.publicEvents;
    if (events.length > _shownEvents) {
      final text = events.sublist(_shownEvents).join('\n\n');
      _shownEvents = events.length;
      await _showText('Day ${engine.gameState.day}', text);
    }
  }

  Future<void> _afterAction() async {
    setState(() {});
    _store.saveProgress(engine.gameState);
    await _showNewEvents();
    if (!mounted) return;
    if (engine.gameState.currentPhase == DayPhase.gameOver) await _showEnding();
  }

  Future<void> _showEnding() {
    final good = engine.gameState.winner == roles.Alignment.Good;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (d) => AlertDialog(
        title: Text(good ? 'Justice' : 'Defeat'),
        content: Text(good ? goodEnding : evilEnding),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(d);
              Navigator.pop(context); // back to the main menu
            },
            child: const Text('Main menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(d);
              _restart();
            },
            child: const Text('Play again'),
          ),
        ],
      ),
    );
  }

  void _restart() {
    engine.newGame();
    _shownEvents = 0;
    _store.startNewGame(engine.scenario);
    setState(() {});
    _showNewEvents();
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
          onMemberPressed: onMemberPressed,
          statusText: _status,
          actionLabel: _actionLabel,
          onAction: _advance,
          onEvidence: () => selectTab(GameNavTab.evidence),
          onHelp: () => selectTab(GameNavTab.help),
        ),

        // Evidence Screen
        EvidenceScreen(
          townMembers: _npcs.map((c) => c.name).toList(),
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