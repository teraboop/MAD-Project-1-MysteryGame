import '../models/game_state.dart';
import '../models/character.dart';
import '../data/scenarios.dart' as data;
import 'win_checker.dart';

class GameEngine {
  GameState gameState = GameState();
  final data.Scenario scenario;
  GameEngine({data.Scenario? scenario}) : scenario = scenario ?? data.scenario;

  void newGame() {
    gameState = GameState();
    gameState.characters = [
      for (final c in scenario.cast)
        Character(
          id: c.id,
          name: c.name,
          role: c.role,
          isHuman: c.isHuman,
          isAlive: true,
        ),
    ];
    gameState.publicEvents.add(scenario.intro);
  }

  Character _find(int id) => gameState.characters.firstWhere(
    (c) => c.id == id,
    orElse: () => throw ArgumentError('Character not found')
  );

  data.ScriptedLine talkTo(int characterID) {
    if (gameState.currentPhase != DayPhase.conversations) {
      throw StateError('Cannot talk to characters outside of conversations phase');
    }
    final character = _find(characterID);
    if (!character.isAlive) {
      throw StateError('Character is not alive');
    }
    if (character.isHuman){
      throw StateError('Why are you talking to yourself?');
    }
    final line = scenario.getConversation(gameState, character.id);
    final entry = 'Day ${gameState.day}: ${line.text}';
    final heardBefore = gameState.heard[character.id]?.contains(entry) ?? false;
    if (!heardBefore) {
      gameState.heard.putIfAbsent(character.id, () => []).add(entry);
      gameState.conversationLog.add(line);
    }
    return line;
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
        throw StateError('Choose someone to execute before the day ends');
      case DayPhase.night:
        resolveNightActions();
        if (gameState.currentPhase == DayPhase.gameOver) break;
        gameState.day++;
        gameState.currentPhase = DayPhase.morning;
        break;
      case DayPhase.gameOver:
        break;
    }
  }

  // Moves to night (or ends the game); call advancePhase() afterwards to run the night.
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
    final night = scenario.nights.firstWhere(
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
      gameState.publicEvents.add('${_find(victim).name} was killed by the Possessed.');
    } else {
      gameState.publicEvents.add('The night passed quietly.');
    }
    gameState.publicEvents.addAll(night.morningEvents);
    checkWinCondition(gameState);
  }

  void endGame() {
    gameState.currentPhase = DayPhase.gameOver;
  }

}