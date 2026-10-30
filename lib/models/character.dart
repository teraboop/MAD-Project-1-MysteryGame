import '../data/role_definitions.dart';

class CharacterProfile { 
  final String name;

  const CharacterProfile({required this.name});
}

class Character {
  final String name;
  final Role role;
  bool isAlive;

   Character({required this.name, required this.role, this.isAlive = true});
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
  assert(roster.length == 9);
  