enum ClueStrength {
  abilityText,
  hint
}
class Clue {
  String text;
  ClueStrength strength;

  Clue({required this.text, required this.strength});
}
class Conversation {
  final int speakerId;
  final String text;
  final Clue? clue;

  Conversation({required this.speakerId, required this.text, this.clue});
}