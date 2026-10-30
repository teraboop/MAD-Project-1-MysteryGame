import 'dart:math';
import '../data/role_definitions.dart';
final List<Role> allRoles = [
  investigator,
  seer,
  physician,
  prophet,
  mortician,
  hunter,
  siren,
  possessed,
  saboteur,
  afterlifer,
  historian,
];

List<Role> _pick(Alignment alignment, int count, Random rng) {
  final candidates = allRoles.where((r) => r.alignment == alignment).toList()..shuffle(rng);
  assert(candidates.length >= count, 'Need $count $alignment roles, only ${candidates.length} defined');
  return candidates.take(count).toList();
}

List<Role> buildRolePool(Random rng, {int good = 6, int neutral = 1, int evil = 2}) {
  return [
    ..._pick(Alignment.Good, good, rng),
    ..._pick(Alignment.Neutral, neutral, rng),
    ..._pick(Alignment.Evil, evil, rng),
  ];
}