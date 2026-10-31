import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import '../lib/data/role_definitions.dart';
import '../lib/engine/role_pool_builder.dart';

void main() {
  test('Role pool builder creates a valid role pool, 6 good, 1 neutral, 2 evil', () {
    final pool = buildRolePool(Random(1));
    int count(Alignment a) => pool.where((r) => r.alignment == a).length;
    
    expect(pool.length, 9);
    expect(count(Alignment.Good), 6);
    expect(count(Alignment.Neutral), 1);
    expect(count(Alignment.Evil), 2);

  });

  test('Pool has no duplicate roles', () {
    final pool = buildRolePool(Random(1));
    expect(pool.toSet().length, pool.length);
  });
}