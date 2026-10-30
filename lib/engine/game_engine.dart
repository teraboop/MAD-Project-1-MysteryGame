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
}