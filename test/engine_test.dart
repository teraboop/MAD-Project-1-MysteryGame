import 'package:flutter_test/flutter_test.dart';
import 'package:proj01/data/role_definitions.dart';
import 'package:proj01/data/scenarios.dart';
import 'package:proj01/engine/game_engine.dart';
import 'package:proj01/models/game_state.dart';

// Plays one full day: morning -> conversations -> voting -> execute -> night -> next morning.
void playDay(GameEngine e, int executeId) {
  e.advancePhase(); // morning -> conversations
  e.advancePhase(); // conversations -> voting
  e.executeCharacter(executeId);
  if (e.gameState.currentPhase != DayPhase.gameOver) e.advancePhase(); // run the night
}

void main() {
  late GameEngine e;
  setUp(() => e = GameEngine()..newGame());

  test('executing Jerry on day 1 wins for good', () {
    playDay(e, jerryId);
    expect(e.gameState.winner, Alignment.Good);
  });

  test('executing Jerry on day 2 wins for good', () {
    playDay(e, aliceId);
    expect(e.gameState.currentPhase, DayPhase.morning);
    expect(e.gameState.day, 2);
    playDay(e, jerryId);
    expect(e.gameState.winner, Alignment.Good);
  });

  test('executing the wrong people lets evil win', () {
    playDay(e, aliceId);
    playDay(e, bobId);
    if (e.gameState.currentPhase != DayPhase.gameOver) playDay(e, dianaId);
    expect(e.gameState.winner, Alignment.Evil);
  });

  test('night 1 kills Frank', () {
    playDay(e, aliceId);
    expect(e.gameState.characters.firstWhere((c) => c.id == frankId).isAlive, isFalse);
  });

  test('three conversations per day, repeats are free', () {
    e.advancePhase(); // morning -> conversations
    e.talkTo(aliceId);
    e.talkTo(aliceId);
    expect(e.gameState.conversationsLeft, 2);
    e.talkTo(bobId);
    e.talkTo(charlieId);
    expect(e.gameState.conversationsLeft, 0);
    expect(() => e.talkTo(dianaId), throwsStateError);
  });

  test('cannot talk to the dead or to yourself', () {
    e.advancePhase(); // morning -> conversations
    expect(() => e.talkTo(youId), throwsStateError);
    e.gameState.characters.firstWhere((c) => c.id == aliceId).isAlive = false;
    expect(() => e.talkTo(aliceId), throwsStateError);
  });

  test('cannot skip the execution', () {
    e.advancePhase();
    e.advancePhase();
    expect(() => e.advancePhase(), throwsStateError);
  });
}
