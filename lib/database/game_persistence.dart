import 'package:flutter/foundation.dart';
import '../data/scenarios.dart';
import '../models/game_state.dart';
import 'database_helper.dart';

// Keeps the SQLite database in step with the in-memory game.
// Every call swallows errors so a database problem never stops the game.
class GamePersistence {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<T?> _safe<T>(String what, Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      debugPrint('Database error ($what): $e');
      return null;
    }
  }

  // CREATE: replace last playthrough's cast and evidence with a fresh one.
  Future<void> startNewGame(Scenario scenario) => _safe('startNewGame', () async {
        for (final e in await _db.getEvidence()) {
          await _db.deleteEvidence(e['id'] as int);
        }
        for (final m in await _db.getTownMembers()) {
          await _db.deleteTownMember(m['id'] as int);
        }
        for (final c in scenario.cast) {
          await _db.createTownMember(id: c.id, name: c.name, role: c.role.name);
        }
        await _db.resetGame();
      });

  // UPDATE: deaths, day and phase.
  Future<void> saveProgress(GameState g) => _safe('saveProgress', () async {
        for (final c in g.characters) {
          await _db.updateTownMember(id: c.id, isAlive: c.isAlive);
        }
        await _db.updateGameState(
          dayNumber: g.day,
          phase: _phaseName(g.currentPhase),
          conversationsUsed: 3 - g.conversationsLeft,
          isFinished: g.currentPhase == DayPhase.gameOver,
        );
      });

  // CREATE: remember what a character told the player.
  Future<void> recordHeard(int characterId, int day, ScriptedLine line) =>
      _safe('recordHeard', () async {
        await _db.createEvidence(
          title: 'Day $day',
          description: line.text,
          discovered: true,
          memberId: characterId,
        );
        final clue = line.clue;
        if (clue != null) {
          await _db.createEvidence(
            title: 'Clue (Day $day)',
            description: clue.text,
            discovered: true,
            memberId: characterId,
          );
        }
      });

  // READ: everything the player has learned from one character.
  // Returns null if the database is unavailable.
  Future<List<String>?> evidenceFor(int characterId) => _safe('evidenceFor', () async {
        final rows = await _db.getEvidence(discoveredOnly: true, memberId: characterId);
        return [for (final r in rows) '${r['title']}: ${r['description']}'];
      });

  String _phaseName(DayPhase p) {
    switch (p) {
      case DayPhase.night:
        return 'night';
      case DayPhase.gameOver:
        return 'finished';
      default:
        return 'day';
    }
  }
}
