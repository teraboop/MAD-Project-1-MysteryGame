
import 'package:flutter/material.dart';
import 'screens/menu.dart';

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

      // Define the application's color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
      ),

      // Display our custom main menu
      home: MenuScreen(
        onPlay: () {
          debugPrint('Play pressed');
        },
        onContinue: null,
        onOptions: () {
          debugPrint('Options pressed');
        },
        onCredits: () {
          debugPrint('Credits pressed');
        },
      ),
    );
  }
}