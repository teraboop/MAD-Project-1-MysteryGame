import 'character.dart';
import 'conversation.dart';

enum DayPhase {morning, conversations, voting, night, gameOver}
class GameState {
  
  DayPhase currentPhase;
  int conversationsLeft = 3;
  List<Character> characters = [];
  List publicEvents = [];
  List<Conversation> conversationLog = [];
  int day = 1;
  GameState({this.currentPhase = DayPhase.morning});

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
