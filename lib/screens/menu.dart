import 'package:flutter/material.dart';
import 'widgets/game_button.dart';

// Main menu screen
class MenuScreen extends StatelessWidget {
  // Functions supplied by the parent to handle menu actions
  final VoidCallback onPlay;
  final VoidCallback? onContinue;
  final VoidCallback onHowToPlay;
  final VoidCallback onCredits;

  // Constructor
  const MenuScreen({
    super.key,
    required this.onPlay,
    this.onContinue,
    required this.onHowToPlay,
    required this.onCredits,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main content of the screen
      body: SafeArea( // Prevents overlapping UI
        child: Center(  // Positions child in the middle of the space
          child: Column(  // Arranged children vertically
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Tells column to occupy only as much space as its contents need
            children: [
              // Game Title
              const Text(
                'Bloody Mystery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Space between title and buttons
              const SizedBox(height: 40),

              // Start new game
              GameButton(
                text: 'Play',
                width: 230,
                height: 55,
                onPressed: onPlay,
              ),

              // Space between buttons
              const SizedBox(height: 12),

              // Continue saved game
              GameButton(
                text: 'Continue',
                width: 230,
                height: 55,
                onPressed: onContinue,
              ),

              const SizedBox(height: 12),

              // Open options
              GameButton(
                text: 'How to Play',
                width: 230,
                height: 55,
                onPressed: onHowToPlay,
              ),

              const SizedBox(height: 12),

              // View credits
              GameButton(
                text: 'Credits',
                width: 230,
                height: 55,
                onPressed: onCredits,
              ),
            ]
          )
        )
      )
    );
  }
}