import 'character.dart';
import 'conversation.dart';
import '../data/scenarios.dart';
import '../data/role_definitions.dart';

enum DayPhase {morning, conversations, voting, night, gameOver}
class GameState {
  Alignment? winner;
  
  DayPhase currentPhase;
  int conversationsLeft = 3;
  List<Character> characters = [];
  List publicEvents = [];
  List<ScriptedLine> conversationLog = [];
  int day = 1;
  GameState({this.currentPhase = DayPhase.morning});

  Alignment goodWin() {
    currentPhase = DayPhase.gameOver;
    winner = Alignment.Good;
    return winner!;
  }

  Alignment evilWin() {
    currentPhase = DayPhase.gameOver;
    winner = Alignment.Evil;
    return winner!;
  }



}
