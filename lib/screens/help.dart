
import 'package:flutter/material.dart';
import 'widgets/game_nav_bar.dart';

class HelpScreen extends StatelessWidget {
  final VoidCallback onTown;
  final VoidCallback onEvidence;

  const HelpScreen({
    super.key,
    required this.onTown,
    required this.onEvidence,
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

                          // Placeholder chatbot message
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Welcome! Eventually, I will help '
                              'you review what you have learned '
                              'about the other town members.\n\n'
                              'You will be able to ask questions '
                              'about suspects, conversations, '
                              'and evidence.\n\n'
                              'Chat functionality coming soon!',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Future chatbot input field
                    const TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Ask about a town member...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.send),
                      ),
                    ),
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