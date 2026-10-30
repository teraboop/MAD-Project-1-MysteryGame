import 'character.dart';

enum DayPhase {morning, conversations, voting, gameOver};
class GameState {
  
  DayPhase? currentPhase;
  late int conversationsLeft;
  List<Character> characters = [];
  List publicEvents = [];
  GameState({this.currentPhase, this.conversationsLeft = 3});
}
