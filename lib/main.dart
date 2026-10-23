
import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'screens/town.dart';
import 'screens/evidence.dart';

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
            openTownScreen(context);
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

// Navigate from the main menu to the Town Screen
void openTownScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (townContext) => TownScreen(
        townMembers: townMembers,

        onMemberPressed: (name) {
          debugPrint('$name selected');
        },

        // Open Evidence Screen when Evidence is pressed
        onEvidence: () {
          openEvidenceScreen(townContext);
        },

        onHelp: () {
          debugPrint('Help pressed');
        },
      ),
    ),
  );
}

// Navigate from the Town Screen to the Evidence Screen
void openEvidenceScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (evidenceContext) => EvidenceScreen(
        townMembers: townMembers,

        onMemberPressed: (name) {
          debugPrint('Viewing evidence for $name');
        },

        // Return to Town Screen when Town is pressed
        onTown: () {
          Navigator.pop(evidenceContext);
        },

        onHelp: () {
          debugPrint('Help pressed');
        },
      ),
    ),
  );
}