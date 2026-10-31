import '../data/role_definitions.dart';
import '../engine/role_pool_builder.dart';
import 'dart:math';

class CharacterProfile { 
  final String name;

  const CharacterProfile({required this.name});
}

class Character {
  final String name;
  final Role role;
  final int id;
  bool isAlive;
  late bool isHuman;

   Character({required this.name, required this.role, required this.id, this.isAlive = true});
}

const Roster = [
  CharacterProfile(name: 'Alice'),
  CharacterProfile(name: 'Bob'),
  CharacterProfile(name: 'Charlie'),
  CharacterProfile(name: 'David'),
  CharacterProfile(name: 'Eve'),
  CharacterProfile(name: 'Frank'),
  CharacterProfile(name: 'Grace'),
  CharacterProfile(name: 'Hank'),
  CharacterProfile(name: 'Ivy'),
  CharacterProfile(name: 'Jack'),
  CharacterProfile(name: 'Karen'),
  CharacterProfile(name: 'Leo'),
  CharacterProfile(name: 'Mona'),
  CharacterProfile(name: 'Nina'),
  CharacterProfile(name: 'Oscar'),
  CharacterProfile(name: 'Paul'),
  CharacterProfile(name: 'Quinn'),
  CharacterProfile(name: 'Rita'),
  CharacterProfile(name: 'Sam'),
  CharacterProfile(name: 'Tina'),
  CharacterProfile(name: 'Uma'),
  CharacterProfile(name: 'Victor'),
  CharacterProfile(name: 'Wendy'),
  CharacterProfile(name: 'Xander'),
  CharacterProfile(name: 'Yara'),
  CharacterProfile(name: 'Zane'),
];


List<Character> assignRoles(List<CharacterProfile> roster, List<Role>rolePool, Random rng) {
  final cast = ([...roster]..shuffle(rng)).take(rolePool.length).toList();
  final roles = [...rolePool]..shuffle(rng);
  return [
    for (var i = 0; i < cast.length; i++)
      Character(name: cast[i].name, role: roles[i], id: i),
  ];
}
  