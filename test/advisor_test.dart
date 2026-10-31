import 'package:flutter_test/flutter_test.dart';
import 'package:proj01/data/scenarios.dart';
import 'package:proj01/engine/advisor.dart';
import 'package:proj01/engine/game_engine.dart';

void main() {
  test('advisor suggests unheard people, then the top suspect', () {
    final e = GameEngine()..newGame();
    e.advancePhase(); // morning -> conversations
    expect(advise(e.gameState), contains('You have not heard from'));

    e.talkTo(jerryId);
    e.talkTo(aliceId);
    e.talkTo(bobId);
    e.talkTo(charlieId);
    e.talkTo(dianaId);
    e.talkTo(frankId);
    e.advancePhase(); // -> voting
    final text = advise(e.gameState);
    expect(text, contains('Day 1 summary'));
    expect(text, contains('Suggestion:'));
  });

  test('advisor points at Jerry once the evidence builds up', () {
    final e = GameEngine()..newGame();
    e.advancePhase();
    e.advancePhase();
    e.executeCharacter(aliceId);
    e.advancePhase(); // night 1
    e.advancePhase(); // morning -> conversations, day 2
    for (final id in [bobId, charlieId, dianaId, jerryId]) {
      e.talkTo(id);
    }
    e.advancePhase(); // -> voting
    expect(advise(e.gameState), contains('Consider executing Jerry'));
  });
}
