import '../models/game_state.dart';

void checkWinCondition(GameState gameState) {
  int aliveCharacters = 0;
  for (var character in gameState.characters) {
    if (character.isAlive) {
      aliveCharacters++;
    }
    if(!character.isAlive && character.role.name == 'possessed') {
      print('Possessed character is dead.');
      print('Good win condition met.');
      gameState.goodWin();
      return;
    }
  }
  for (var character in gameState.characters) {
    if ((character.isAlive && character.role.name == 'possessed') && aliveCharacters < 3) {
      print('Possessed character is alive but less than 3 characters remain.');
      print('Evil win condition met.');
      gameState.evilWin();
      return;
    }
  }
  return;
}