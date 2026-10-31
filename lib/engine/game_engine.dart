import '../models/game_state.dart';
import '../data/role_definitions.dart';
import '../engine/role_pool_builder.dart';
import '../models/character.dart';
import '../models/conversation.dart';
import '../data/scenarios.dart';
import 'dart:math';
class GameEngine {
  GameState gameState = GameState();
  final Random rng = Random();

  void newGame(Scenario s, GameState gameState) {
    //final rolePool = buildRolePool(rng);
    //gameState.characters = assignRoles(Roster, rolePool, rng);
    final List<Character> characterArray = [];
    for (var c in s.cast) {
      characterArray.add(Character(
        id: c.id,
        name: c.name,
        role: c.role,
        isHuman: c.isHuman,
        isAlive: true,
      ));
    }
    gameState.characters = characterArray;
  }

  Character _find(int id) => gameState.characters.firstWhere(
    (c) => c.id == id,
    orElse: () => throw ArgumentError('Character not found')
  );

  ScriptedLine talkTo(int characterID) {
    if (gameState.currentPhase != DayPhase.conversations) {
      throw StateError('Cannot talk to characters outside of conversations phase');
    }
    if (gameState.conversationsLeft <= 0) {
      throw StateError('No conversations left for today');
    }
    final character = _find(characterID);
    if (!character.isAlive) {
      throw StateError('Character is not alive');
    }
    if (character.isHuman){
      throw StateError('Why are you talking to yourself?');
    }
    final scriptedLine = scenario.getConversation(gameState, character.id);
    gameState.conversationLog.add(scriptedLine);
    return scriptedLine;
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
      case DayPhase.night:
        gameState.day++;
        gameState.conversationsLeft = 3;
        gameState.currentPhase = DayPhase.morning;
        break;
      case DayPhase.gameOver:
        break;
      default:
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