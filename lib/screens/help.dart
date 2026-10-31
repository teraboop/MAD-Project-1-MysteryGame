
import 'package:flutter/material.dart';
import 'widgets/game_nav_bar.dart';
import 'widgets/game_button.dart';

class HelpScreen extends StatelessWidget {
  final VoidCallback onTown;
  final VoidCallback onEvidence;
  final List<String> messages;
  final VoidCallback onAsk;

  const HelpScreen({
    super.key,
    required this.onTown,
    required this.onEvidence,
    this.messages = const [],
    required this.onAsk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Navigation bar at the top
            GameNavBar(
              selectedTab: GameNavTab.help,
              onTown: onTown,
              onEvidence: onEvidence,
              onHelp: () {},
            ),

            // Main Help screen content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Chatbot conversation area
                    Expanded(
                      child: ListView(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.smart_toy_outlined,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Town Assistant',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Assistant messages
                          for (final m in messages)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(m),
                            ),
                        ],
                      ),
                    ),

                    GameButton(text: 'Summarize and advise me', onPressed: onAsk),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}