import 'package:flutter_test/flutter_test.dart';
import 'package:algorithmic_dungeon/algorithms/dijkstra.dart';
import 'package:algorithmic_dungeon/data/sample_levels.dart';
import 'package:algorithmic_dungeon/models/dungeon_level.dart';
import 'package:algorithmic_dungeon/models/grid_position.dart';

void main() {
  group('SampleLevels.level1 Verification', () {
    final level = SampleLevels.level1;
    final engine = DijkstraEngine();

    test('level1 topology and dimension constraints', () {
      expect(level.rows, equals(6));
      expect(level.cols, equals(6));
      expect(level.start, equals(const GridPosition(0, 0)));
      expect(level.exit, equals(const GridPosition(5, 5)));
      expect(level.initialEnergy, equals(60));
      expect(level.maxEnergy, equals(100));
    });

    test('exit is guaranteed reachable by Dijkstra with optimal cost 10', () {
      final result = engine.findShortestPath(
        level: level,
        start: level.start,
        goal: level.exit,
      );

      expect(result.hasPath, isTrue);
      expect(result.totalCost, equals(10));
      expect(result.path.length, equals(11)); // 11 positions = 10 transitions
      expect(result.path.first, equals(const GridPosition(0, 0)));
      expect(result.path.last, equals(const GridPosition(5, 5)));
      expect(
        result.verifyPathCost(
          level: level,
          expectedStart: level.start,
          expectedGoal: level.exit,
        ),
        isTrue,
      );

      // Verify that optimal route cost (10) is well within initial energy (60)
      expect(result.totalCost!, lessThanOrEqualTo(level.initialEnergy));
    });

    test('demonstrates step count vs weighted cost distinction', () {
      // From (2, 0) to (2, 4):
      // Direct center shortcut via row 2 has hazards: (2,1)[5], (2,2)[5], (2,3)[5], (2,4)[1] = cost 16 (4 steps).
      // Perimeter detour via row 4 has all floor: cost 8 (8 steps).
      final result = engine.findShortestPath(
        level: level,
        start: const GridPosition(2, 0),
        goal: const GridPosition(2, 4),
      );

      expect(result.hasPath, isTrue);
      expect(result.totalCost, equals(8)); // Prefers lower cost 8 over 16
      expect(result.path.length, equals(9)); // 8 steps
      expect(
        result.verifyPathCost(
          level: level,
          expectedStart: const GridPosition(2, 0),
          expectedGoal: const GridPosition(2, 4),
        ),
        isTrue,
      );
    });
  });

  group('SampleLevels Multi-Difficulty & Reachability Verification', () {
    final engine = DijkstraEngine();

    test('all 9 levels have valid configurations and are reachable within energy budgets', () {
      final levels = SampleLevels.allLevels;
      expect(levels.length, equals(9));

      for (final lvl in levels) {
        expect(lvl.isInBounds(lvl.start), isTrue, reason: '${lvl.name} start in bounds');
        expect(lvl.isInBounds(lvl.exit), isTrue, reason: '${lvl.name} exit in bounds');
        expect(lvl.tileAt(lvl.start).isTraversable, isTrue);
        expect(lvl.tileAt(lvl.exit).isTraversable, isTrue);

        final result = engine.findShortestPath(
          level: lvl,
          start: lvl.start,
          goal: lvl.exit,
        );

        expect(result.hasPath, isTrue, reason: '${lvl.name} must be solvable');
        expect(result.totalCost, isNotNull);
        expect(
          result.totalCost!,
          lessThanOrEqualTo(lvl.initialEnergy),
          reason: '${lvl.name} optimal cost (${result.totalCost}) must fit within initial energy (${lvl.initialEnergy})',
        );
      }
    });

    test('difficulty buckets are populated correctly', () {
      expect(SampleLevels.byDifficulty(DungeonDifficulty.apprentice).length, equals(3));
      expect(SampleLevels.byDifficulty(DungeonDifficulty.explorer).length, equals(3));
      expect(SampleLevels.byDifficulty(DungeonDifficulty.cryptmaster).length, equals(3));
    });

    test('getNextLevel progresses correctly', () {
      expect(SampleLevels.getNextLevel('level_1')?.id, equals('level_2'));
      expect(SampleLevels.getNextLevel('level_8')?.id, equals('level_9'));
      expect(SampleLevels.getNextLevel('level_9'), isNull);
    });
  });
}

