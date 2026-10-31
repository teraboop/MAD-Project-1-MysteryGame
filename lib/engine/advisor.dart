import '../models/game_state.dart';

// Rule-based helper: summarizes what the player has learned and suggests one action.
String advise(GameState g) {
  final npcs = g.characters.where((c) => !c.isHuman).toList();
  final alive = npcs.where((c) => c.isAlive).toList();
  final dead = npcs.where((c) => !c.isAlive).map((c) => c.name).toList();

  final score = <int, int>{};
  for (final line in g.conversationLog) {
    line.suspicion.forEach((id, p) => score[id] = (score[id] ?? 0) + p);
  }
  final clues = [
    for (final line in g.conversationLog)
      if (line.clue != null) line.clue!.text,
  ];

  final today = 'Day ${g.day}:';
  final notSpokenTo = alive
      .where((c) => !(g.heard[c.id]?.any((e) => e.startsWith(today)) ?? false))
      .map((c) => c.name)
      .toList();

  final summary = StringBuffer('Day ${g.day} summary\n');
  summary.writeln(dead.isEmpty ? '• Nobody has died yet.' : '• Dead: ${dead.join(', ')}.');
  summary.writeln(clues.isEmpty
      ? '• You have no solid clues yet.'
      : '• Clues: ${clues.join(' ')}');

  final ranked = [...alive]..sort((a, b) => (score[b.id] ?? 0).compareTo(score[a.id] ?? 0));
  final top = ranked.isEmpty ? 0 : (score[ranked.first.id] ?? 0);
  final leaders = ranked.where((c) => (score[c.id] ?? 0) == top).toList();
  if (top > 0) {
    summary.writeln('• Most suspicious so far: ${leaders.map((c) => c.name).join(', ')}.');
  }

  final String suggestion;
  if (g.currentPhase == DayPhase.voting) {
    if (top <= 0) {
      suggestion = 'Nobody stands out yet. Go with your gut, or learn more tomorrow.';
    } else if (leaders.length == 1) {
      suggestion = 'Consider executing ${leaders.first.name}; the evidence points at them most.';
    } else {
      suggestion = 'It is close between ${leaders.map((c) => c.name).join(' and ')}. '
          'Weigh their stories against each other before you choose.';
    }
  } else if (notSpokenTo.isNotEmpty) {
    suggestion = 'You have not heard from ${notSpokenTo.join(', ')} today. '
        'Talk to them before you go to the vote.';
  } else {
    suggestion = 'You have heard everyone today. Compare their stories, then go to the vote.';
  }

  return '$summary\nSuggestion: $suggestion';
}
