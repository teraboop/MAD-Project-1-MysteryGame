enum TemplateKind {
  greeting,
  claim,
  clue,
  accusation,
  deflection,
  description
}

enum Tone {
  friendly,
  suspicious,
  evasive,
  neutral
}

class DialogueTemplate {
  final String id;
  final TemplateKind kind;
  final String text;
  final Set<Tone> tones;
  final Set<String> roleIds;
  final bool? speakerIsEvil;

  const DialogueTemplate({
    required this.id,
    required this.kind,
    required this.text,
    this.tones = const {},
    this.roleIds = const {},
    this.speakerIsEvil,
  });
}

const greetingTemplates = [
  DialogueTemplate(
    id: 'greeting_template_1',
    kind: TemplateKind.greeting,
    text: 'Hello there!',
    tones: {Tone.friendly},
  ),
  DialogueTemplate(
    id: 'greeting_template_2',
    kind: TemplateKind.greeting,
    text: 'Good to see you!',
    tones: {Tone.friendly},
  ),
  DialogueTemplate(
    id: 'greeting_template_3',
    kind: TemplateKind.greeting,
    text: 'How could this have happened?',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_4',
    kind: TemplateKind.greeting,
    text: 'What brings you to me?',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_5',
    kind: TemplateKind.greeting,
    text: 'Greetings!',
    tones: {Tone.friendly},
  ),
  DialogueTemplate(
    id: 'greeting_template_6',
    kind: TemplateKind.greeting,
    text: 'What a horrible day.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_7',
    kind: TemplateKind.greeting,
    text: 'Haunting day, what a poor sap indeed.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_8',
    kind: TemplateKind.greeting,
    text: 'Ah, another day in this wretched place.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_9',
    kind: TemplateKind.greeting,
    text: 'The sun rises, yet my heart remains heavy.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'greeting_template_10',
    kind: TemplateKind.greeting,
    text: 'You seem like trouble.',
    tones: {Tone.suspicious},
  ),
  DialogueTemplate(
    id: 'greeting_template_11',
    kind: TemplateKind.greeting,
    text: 'I have a bad feeling about this.',
    tones: {Tone.suspicious},
  ),
  DialogueTemplate(
    id: 'greeting_template_12',
    kind: TemplateKind.greeting,
    text: 'I don\'t trust you one bit.',
    tones: {Tone.suspicious},
  ),
];

const claimTemplates = [
  DialogueTemplate(
    id: 'investigator_claim_part1',
    kind: TemplateKind.claim,
    text: 'I have gathered important evidence. Upon investigating {target1} and {target2}, I have come to some conclusions.',
    tones: {Tone.neutral},
    roleIds: {'investigator', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'investigator_claim_part2a',
    kind: TemplateKind.claim,
    text: 'It seems the two that I have investigated are both innocent.',
    tones: {Tone.neutral},
    roleIds: {'investigator', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'investigator_claim_part2b',
    kind: TemplateKind.claim,
    text: 'It appears that one of the investigated parties is suspicious.',
    tones: {Tone.neutral},
    roleIds: {'investigator', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'seer_claim',
    kind: TemplateKind.claim,
    text: 'I have seen the truth about {target}. \n It seems they are {targetAlignment}',
    tones: {Tone.neutral},
    roleIds: {'seer', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'physician_claim',
    kind: TemplateKind.claim,
    text: 'I protect those who cannot protect themselves.',
    tones: {Tone.neutral},
    roleIds: {'physician', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'prophet_claim',
    kind: TemplateKind.claim,
    text: 'I have foreseen the tampering of {target}\'s ability last night.',
    tones: {Tone.neutral},
    roleIds: {'prophet', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'mortician_claim_part1',
    kind: TemplateKind.claim,
    text: 'I have examined the dead and learned their secrets.',
    tones: {Tone.neutral},
    roleIds: {'mortician', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'mortician_claim_part2',
    kind: TemplateKind.claim,
    text: 'I have found that {target} was {targetRole}.',
    tones: {Tone.neutral},
    roleIds: {'mortician', 'possessed', 'saboteur', 'siren'},
  ),
  DialogueTemplate(
    id: 'hunter_claim',
    kind: TemplateKind.claim,
    text: 'I killed {target}, my wife can finally rest.',
    tones: {Tone.neutral},
    roleIds: {'hunter', 'possessed', 'saboteur', 'siren'},
  ),
];

const conversationTemplates = [
  DialogueTemplate(
    id:'giving_information',
    kind: TemplateKind.description,
    text: 'I\'m rather suspicious about {target}',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'deny',
    kind: TemplateKind.description,
    text: 'I deny the accusation.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'agree',
    kind: TemplateKind.description,
    text: 'I agree with that statement.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'disagree',
    kind: TemplateKind.description,
    text: 'I disagree with that statement.',
    tones: {Tone.neutral},
  ),
  DialogueTemplate(
    id: 'uncertain',
    kind: TemplateKind.description,
    text: 'I am uncertain about that.',
    tones: {Tone.neutral},
  ),
];