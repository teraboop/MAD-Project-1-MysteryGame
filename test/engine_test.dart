import 'package:flutter_test/flutter_test.dart';
import '../lib/engine/game_engine.dart';
import '../lib/data/role_definitions.dart';

void main() {
  test('executing Jerry on day 2 wins', () {
    final e = GameEngine()..newGame();
    e.advancePhase();            // morning -> conversations
    e.advancePhase();            // -> voting
    e.advancePhase();            // day 1 -> night
    e.advancePhase();            // night resolves, day 2 morning (Frank dies)
    e.advancePhase();            // -> conversations
    e.advancePhase();            // -> voting
    e.executeCharacter(e.scenario!.cast.firstWhere((c) => c.name == 'Jerry').id);
    expect(e.gameState.winner, Alignment.Good);
  });
}