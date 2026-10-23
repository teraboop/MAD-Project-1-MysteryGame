
import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'screens/town.dart';

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

      // Display main menu when the app starts
      home: Builder(
        builder: (context) => MenuScreen(
          // Navigate to Town Screen when Play is pressed
          onPlay: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TownScreen(
                  // Placeholder names until game data is implemented
                  townMembers: const [
                    'Town Member 1',
                    'Town Member 2',
                    'Town Member 3',
                    'Town Member 4',
                    'Town Member 5',
                    'Town Member 6',
                    'Town Member 7',
                    'Town Member 8',
                  ],

                  // Temporary callbacks
                  onMemberPressed: (name) {
                    debugPrint('$name selected');
                  },

                  onEvidence: () {
                    debugPrint('Evidence pressed');
                  },

                  onHelp: () {
                    debugPrint('Help pressed');
                  },
                ),
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