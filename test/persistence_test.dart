import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:proj01/data/scenarios.dart';
import 'package:proj01/database/database_helper.dart';
import 'package:proj01/database/game_persistence.dart';
import 'package:proj01/engine/game_engine.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('database stores the cast, deaths and what the player heard', () async {
    final store = GamePersistence();
    final db = DatabaseHelper.instance;
    final e = GameEngine()..newGame();

    // Create
    await store.startNewGame(e.scenario);
    expect((await db.getTownMembers()).length, e.scenario.cast.length);

    // Create + Read evidence
    e.advancePhase();
    final line = e.talkTo(aliceId);
    await store.recordHeard(aliceId, e.gameState.day, line);
    final heard = await store.evidenceFor(aliceId);
    expect(heard, isNotNull);
    expect(heard!.single, contains(line.text));

    // Update
    e.advancePhase();
    e.executeCharacter(bobId);
    await store.saveProgress(e.gameState);
    expect((await db.getTownMember(bobId))!['is_alive'], 0);
    expect((await db.getGameState())['phase'], 'night');

    // Delete + reset on a new game
    await store.startNewGame(e.scenario);
    expect((await db.getTownMember(bobId))!['is_alive'], 1);
    expect(await store.evidenceFor(aliceId), isEmpty);
  });
}
