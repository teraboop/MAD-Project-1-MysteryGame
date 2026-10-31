import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj01/data/role_definitions.dart';
import 'package:proj01/engine/role_pool_builder.dart';
import 'package:proj01/models/character.dart';

void main() {
  late Random rng;
  test('Role pool builder creates a valid role pool, 6 good, 1 neutral, 2 evil', () {
    rng = Random(1);
    final pool = buildRolePool(rng);
    int count(Alignment a) => pool.where((r) => r.alignment == a).length;
    
    expect(pool.length, 9);
    expect(count(Alignment.Good), 6);
    expect(count(Alignment.Neutral), 1);
    expect(count(Alignment.Evil), 2);

  });

  test('Pool has no duplicate roles', () {
    rng = Random(1);
    final pool = buildRolePool(rng);
    expect(pool.toSet().length, pool.length);
  });

  test('characters have unique ids and names', () {
    rng = Random(1);
    final characters = assignRoles(Roster, buildRolePool(rng), rng);
    final ids = characters.map((c) => c.id).toSet();
    final names = characters.map((c) => c.name).toSet();
    expect(ids.length, characters.length);
    expect(names.length, characters.length);
  });

  test('all characters start alive', () {
    final characters = assignRoles(Roster, buildRolePool(rng), rng);
    for (final c in characters) {
      expect(c.isAlive, isTrue);
    }
  });
}