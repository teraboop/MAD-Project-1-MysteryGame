import '../models/game_state.dart';
import '../data/role_definitions.dart';
import '../engine/role_pool_builder.dart';
import '../models/character.dart';
import 'dart:math';
class GameEngine {
  GameState gameState = GameState();
  final Random rng = Random();

  void newGame() {
    final rolePool = buildRolePool(rng);
    gameState.characters = assignRoles(Roster, rolePool, rng);
  }

  void talkTo(int characterID) {
    final character = gameState.characters.firstWhere((c) => c.id == characterID, orElse: () => throw Exception('Character not found'));
  }

  void advancePhase() {
    switch (gameState.currentPhase) {
      case DayPhase.morning:
        gameState.currentPhase = DayPhase.conversations;
        break;
      case DayPhase.conversations:
        gameState.currentPhase = DayPhase.voting;
        break;
      case DayPhase.voting:
        gameState.currentPhase = DayPhase.gameOver;
        break;
      case DayPhase.gameOver:
        break;
      default:
        gameState.currentPhase = DayPhase.morning;
    }
  }

  void castVote(int characterID, int targetID) {
    final character = gameState.characters.firstWhere((c) => c.id == characterID, orElse: () => throw Exception('Character not found'));
    final target = gameState.characters.firstWhere((c) => c.id == targetID, orElse: () => throw Exception('Target not found'));
    // Implement vote logic here
  }

  void endGame() {
    gameState.currentPhase = DayPhase.gameOver;
  }

}