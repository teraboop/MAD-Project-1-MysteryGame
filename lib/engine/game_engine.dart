import '../models/game_state.dart';
import '../models/character.dart';
import '../data/scenarios.dart' as data;
import 'win_checker.dart';
import 'dart:math';
class GameEngine {
  GameState gameState = GameState();
  data.Scenario? scenario;
  final Random rng = Random();
  GameEngine({data.Scenario? scenario}) : scenario = scenario ?? data.scenario;
  void newGame() {
    final scenario = this.scenario;
    if (scenario == null) throw StateError('No scenario provided');
    //final rolePool = buildRolePool(rng);
    //gameState.characters = assignRoles(Roster, rolePool, rng);
    gameState = GameState();
    final List<Character> characterArray = [];
    for (var c in scenario!.cast) {
      characterArray.add(Character(
        id: c.id,
        name: c.name,
        role: c.role,
        isHuman: c.isHuman,
        isAlive: true,
      ));
    }
    gameState.characters = characterArray;
    gameState.publicEvents.add(scenario!.intro);
  }

  Character _find(int id) => gameState.characters.firstWhere(
    (c) => c.id == id,
    orElse: () => throw ArgumentError('Character not found')
  );

  data.ScriptedLine talkTo(int characterID) {
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
    final data.ScriptedLine scriptedLine = scenario!.getConversation(gameState, character.id);
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
        gameState.currentPhase = DayPhase.night;
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

  void executeCharacter(int targetId) {
  if (gameState.currentPhase != DayPhase.voting) {
    throw StateError('Executions only happen in the voting phase');
  }
  final target = _find(targetId);
  if (target.isHuman) throw StateError('You cannot execute yourself');
  if (!target.isAlive) throw StateError('${target.name} is already dead');

  killCharacter(targetId);
  gameState.publicEvents.add('${target.name} was executed.');
  checkWinCondition(gameState);
  if (gameState.currentPhase != DayPhase.gameOver) {
    gameState.currentPhase = DayPhase.night;
  }
}

  void killCharacter(int characterID) {
    final character = _find(characterID);
    character.isAlive = false;
  }

  void resolveNightActions() {
  final night = scenario!.nights.firstWhere(
    (n) => n.day == gameState.day,
    orElse: () => data.NightEvent(day: gameState.day),
  );

  int? victim = night.victimId;
  if (victim == null) {
    for (final id in night.victimPriority) {
      if (_find(id).isAlive) { victim = id; break; }
    }
  }

  if (victim != null && _find(victim).isAlive) {
    killCharacter(victim);
    gameState.publicEvents.add('${_find(victim).name} was found dead.');
  }
  gameState.publicEvents.addAll(night.morningEvents);
  checkWinCondition(gameState);
}

  void endGame() {
    gameState.currentPhase = DayPhase.gameOver;
  }

}