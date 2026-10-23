enum Alignment{
  Good,
  Neutral,
  Evil
}

class Role {
  final int id;
  final String name;
  final Alignment alignment;
  final String description;
  final bool hasNightAction;

  Role({
    required this.id,
    required this.name,
    required this.alignment,
    required this.description,
    this.hasNightAction = false,
  });
}


Role investigator = Role(
  id: 1,
  name: 'Investigator',
  alignment: Alignment.Good,
  description: 'The investigator chooses two people at the beginning of the game and is told if there is an evil player among them.',
  hasNightAction: true,
);

Role seer = Role(
  id: 2,
  name: 'Seer',
  alignment: Alignment.Good,
  description: 'The seer chooses one player each night and is told their alignment.',
  hasNightAction: true,
);

Role physician = Role(
  id: 3,
  name: 'Physician',
  alignment: Alignment.Good,
  description: 'The physician chooses one player each night to protect from ALL harm.',
  hasNightAction: true,
);

Role prophet = Role(
  id: 4,
  name: 'Prophet',
  alignment: Alignment.Good,
  description: 'The prophet receives a vision showing who\'s ability was tampered with when activated. Two uses.',
  hasNightAction: true,
);

Role mortician = Role(
  id: 5,
  name: 'Mortician',
  alignment: Alignment.Good,
  description: 'The mortician can examine a dead player each night to learn their role.',
  hasNightAction: true,
);

Role hunter = Role(
  id: 6,
  name: 'Hunter',
  alignment: Alignment.Neutral,
  description: 'The hunter has the ability to shoot someone once per game.',
  hasNightAction: true,
);

Role clown = Role(
  id: 7,
  name: 'Clown',
  alignment: Alignment.Neutral,
  description: 'The clown believes he is a different role, and will have an illusion of being that role, and give false information to others accordingly.',
  hasNightAction: false,
);

Role siren = Role(
  id: 8,
  name: 'Siren',
  alignment: Alignment.Neutral,
  description: 'The siren can charm one player each night, forcing them to follow her instructions.',
  hasNightAction: true,
);

Role possessed = Role(
  id: 9,
  name: 'Possessed',
  alignment: Alignment.Evil,
  description: 'The possessed kills a non-evil player each night.',
  hasNightAction: false,
);

Role saboteur = Role(
  id: 10,
  name: 'Saboteur',
  alignment: Alignment.Evil,
  description: 'The saboteur can choose one player each night which causes their night action to fail or give false information.',
  hasNightAction: true,
);



