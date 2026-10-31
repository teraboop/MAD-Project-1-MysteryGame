import 'character.dart';
import '../data/scenarios.dart';
import '../data/role_definitions.dart';

enum DayPhase {morning, conversations, voting, night, gameOver}
class GameState {
  Alignment? winner;
  
  DayPhase currentPhase;
  int conversationsLeft = 3;
  List<Character> characters = [];
  List<String> publicEvents = [];
  List<ScriptedLine> conversationLog = [];
  // What the player has been told, per character: "Day N: text"
  final Map<int, List<String>> heard = {};
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
