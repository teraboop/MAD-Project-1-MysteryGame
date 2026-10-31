import 'character.dart';

enum DayPhase {morning, conversations, voting, gameOver}
class GameState {
  
  DayPhase? currentPhase;
  late int conversationsLeft;
  List<Character> characters = [];
  List publicEvents = [];
  GameState({this.currentPhase, this.conversationsLeft = 3});

  void goodWin() {
    currentPhase = DayPhase.gameOver;
    print('Good win condition met.');
    //Move to good win screen or trigger good win sequence
  }

  void evilWin() {
    currentPhase = DayPhase.gameOver;
    print('Evil win condition met.');
    //Move to loss screen or trigger loss sequence
  }
}
