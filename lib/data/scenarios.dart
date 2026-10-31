import 'role_definitions.dart';
import '../models/conversation.dart';
import '../models/game_state.dart';
import '../models/character.dart';
import '../engine/game_engine.dart';

typedef Condition = bool Function(GameState s);

class ScriptedLine {
  final int day;
  final String text;
  final Clue? clue;
  final Condition? when; // null = always applies
  const ScriptedLine(this.day, this.text, {this.clue, this.when});
}

class CharacterScript {
  final int id;
  final String name;
  final Role role;
  final bool isHuman;
  final List<ScriptedLine> lines;
  const CharacterScript({
    required this.id,
    required this.name,
    required this.role,
    this.isHuman = false,
    this.lines = const [],
  });
}

class NightEvent {
  final int day; // the day that ends with this night
  final int? victimId; // fixed victim
  final List<int> victimPriority; // otherwise: first living id in this list dies
  final List<String> morningEvents;
  const NightEvent({
    required this.day,
    this.victimId,
    this.victimPriority = const [],
    this.morningEvents = const [],
  });
}

class Scenario {
  final List<CharacterScript> cast;
  final List<NightEvent> nights;
  final String intro;
  const Scenario({required this.cast, required this.nights, required this.intro});

  ScriptedLine getConversation(GameState g, int characterId) {
    final script = cast.firstWhere((c) => c.id == characterId);
    final day = g.day;
    return script.lines.firstWhere(
      (line) => line.day == day && (line.when == null || line.when!(g)),
      orElse: () => throw StateError('No conversation available for this character today'),
    );
  }

  int getCharacter(int id) => cast.firstWhere((c) => c.id == id).id;
}

const int youId = 0;
const int aliceId = 1;
const int bobId = 2;
const int charlieId = 3;
const int dianaId = 4;
const int jerryId = 5;
const int frankId = 6;


bool _dead(GameState s, int id) =>
    !s.characters.firstWhere((c) => c.id == id).isAlive;

const String goodEnding =
    'Jerry\'s mask slips as the town closes in. The killings stop. '
    'You have found the Possessed.';
const String evilEnding =
    'The town has been whittled down too far to fight back. '
    'The killer was never going to stop.';

final scenario = Scenario(

  intro: 'Someone in town was murdered last night. You investigated the Seer '
      'and the Physician, and learned that one of them is evil.',
  cast: [
    CharacterScript(id: youId, name: 'You', role: investigator, isHuman: true),

    // Saboteur, claims to be the Seer.
    CharacterScript(id: aliceId, name: 'Alice', role: saboteur, lines: [
      ScriptedLine(1, 'As the Seer, I had a vision that Charlie is evil.'),
      ScriptedLine(2, 'I had no visions last night. Perhaps the spirits are tired of us.'),
      ScriptedLine(
        3,
        'Bob is gone, and still the killing goes on. I had a vision last '
        'night: Jerry is good. Whoever is doing this, it is not him.',
        when: (s) => _dead(s, bobId),
      ),
      ScriptedLine(3, 'I had a vision that Jerry is good. Trust that, if you trust nothing else.'),
    ]),

    // Good, hindered on night 1.
    CharacterScript(id: bobId, name: 'Bob', role: physician, lines: [
      ScriptedLine(1, "Diana was gravely wounded last night. I'm so glad I was around to save her."),
      ScriptedLine(2, "I tried my hardest to save Frank, but something came over me. I don't understand why I couldn't."),
      ScriptedLine(
        3,
        'Alice is gone, so my protection should have held. I guarded Diana '
        'last night and Charlie died instead. I will not make that mistake again.',
        when: (s) => _dead(s, aliceId),
      ),
      ScriptedLine(
        3,
        'Diana is dead. I guarded you last night, Investigator, and I think '
        'that is the only reason you are still standing.',
        when: (s) => _dead(s, dianaId),
      ),
      ScriptedLine(
        3,
        'Charlie died last night. I guarded you, but the killer chose someone '
        'else. Whoever it is, they know exactly who matters.',
      ),
    ]),

    // Good, always dead by day 3.
    CharacterScript(id: charlieId, name: 'Charlie', role: prophet, lines: [
      ScriptedLine(1, 'I have nothing much to say today. I will pray upon our town tonight to reveal any misgivings.'),
      ScriptedLine(
        2,
        'I believe Bob was hindered in some way last night. The divine showed '
        'me his gift failing him. I will ask for another vision tonight.',
        clue: Clue(
          text: "Charlie's vision: Bob's ability was tampered with on night 1.",
          strength: ClueStrength.abilityText,
        ),
      ),
    ]),

    // Good.
    CharacterScript(id: dianaId, name: 'Diana', role: mortician, lines: [
      ScriptedLine(1, "Every day is a hard day in my line of work. I hope to uncover the secrets the dead hide soon."),
      ScriptedLine(
        2,
        'While I was examining Frank last night, I noticed his deep record '
        'keeping of the town. A good and devoted member of our community, gone.',
        clue: Clue(
          text: 'Diana examined Frank: Historian, Good.',
          strength: ClueStrength.abilityText,
        ),
      ),
      ScriptedLine(
        3,
        'I examined Charlie last night. A Prophet, good, and cut down the '
        'same way as Frank. Whoever the killer is, they feared what Charlie saw.',
        clue: Clue(
          text: 'Diana examined Charlie: Prophet, Good.',
          strength: ClueStrength.abilityText,
        ),
      ),
    ]),

    // Possessed, the killer.
    CharacterScript(id: jerryId, name: 'Jerry', role: possessed, lines: [
      ScriptedLine(1, 'That man was gutted like an animal. Someone here executed the technique flawlessly.'),
      ScriptedLine(2, "Another dead, and seemingly in the same manner. I swear I'll find who did this and make them pay."),
      ScriptedLine(
        3,
        'The knife keeps falling no matter who we put down. Diana has stayed '
        'calm through all of it. Ask yourself why.',
        when: (s) => _dead(s, bobId),
      ),
      ScriptedLine(
        3,
        'Another gone, same wounds. The Physician has failed us twice now. '
        "I'd ask why Bob is always nowhere when it matters.",
      ),
    ]),

    // Good, dies night 1.
    CharacterScript(id: frankId, name: 'Frank', role: historian, lines: [
      ScriptedLine(1, 'I believe I saw Bob approaching Diana\'s house last night.'),
    ]),
  ],
  nights: [
    // Night 1: Saboteur blocks Bob, Bob guards Frank, Jerry kills Frank.
    NightEvent(
      day: 1,
      victimId: frankId,
      morningEvents: ['Frank, the Historian, was found dead.'],
    ),
    // Nights 2 and 3: Jerry kills the first living character in this order.
    NightEvent(day: 2, victimPriority: [charlieId, dianaId, bobId]),
    NightEvent(day: 3, victimPriority: [dianaId, bobId, charlieId]),
  ],

  
);
