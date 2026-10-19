import '../models/dungeon_level.dart';
import '../models/dungeon_tile.dart';
import '../models/grid_position.dart';

/// Provides deterministic, hand-crafted levels across multiple difficulty tiers.
class SampleLevels {
  /// The primary deterministic demo level: "The Labyrinth Threshold".
  /// Kept strictly identical for backward compatibility and test verification.
  static DungeonLevel get level1 {
    final List<List<DungeonTile>> grid = [
      // Row 0
      [
        DungeonTile.floor(movementCost: 1), // (0, 0) Start
        DungeonTile.floor(movementCost: 1), // (0, 1)
        DungeonTile.rubble(movementCost: 3), // (0, 2)
        DungeonTile.floor(movementCost: 1), // (0, 3)
        DungeonTile.treasure(movementCost: 1, points: 100), // (0, 4)
        DungeonTile.wall(), // (0, 5)
      ],
      // Row 1
      [
        DungeonTile.floor(movementCost: 1), // (1, 0)
        DungeonTile.wall(), // (1, 1)
        DungeonTile.wall(), // (1, 2)
        DungeonTile.wall(), // (1, 3)
        DungeonTile.floor(movementCost: 1), // (1, 4)
        DungeonTile.wall(), // (1, 5)
      ],
      // Row 2: Central hazardous shortcut
      [
        DungeonTile.floor(movementCost: 1), // (2, 0)
        DungeonTile.hazard(movementCost: 5), // (2, 1)
        DungeonTile.hazard(movementCost: 5), // (2, 2)
        DungeonTile.hazard(movementCost: 5), // (2, 3)
        DungeonTile.floor(movementCost: 1), // (2, 4)
        DungeonTile.wall(), // (2, 5)
      ],
      // Row 3
      [
        DungeonTile.energyPickup(movementCost: 1, energyAmount: 20), // (3, 0)
        DungeonTile.wall(), // (3, 1)
        DungeonTile.wall(), // (3, 2)
        DungeonTile.wall(), // (3, 3)
        DungeonTile.floor(movementCost: 1), // (3, 4)
        DungeonTile.wall(), // (3, 5)
      ],
      // Row 4
      [
        DungeonTile.floor(movementCost: 1), // (4, 0)
        DungeonTile.floor(movementCost: 1), // (4, 1)
        DungeonTile.floor(movementCost: 1), // (4, 2)
        DungeonTile.floor(movementCost: 1), // (4, 3)
        DungeonTile.floor(movementCost: 1), // (4, 4)
        DungeonTile.floor(movementCost: 1), // (4, 5)
      ],
      // Row 5
      [
        DungeonTile.wall(), // (5, 0)
        DungeonTile.wall(), // (5, 1)
        DungeonTile.wall(), // (5, 2)
        DungeonTile.wall(), // (5, 3)
        DungeonTile.wall(), // (5, 4)
        DungeonTile.exit(movementCost: 1), // (5, 5) Exit
      ],
    ];

    return DungeonLevel(
      id: 'level_1',
      name: 'The Labyrinth Threshold',
      rows: 6,
      cols: 6,
      grid: grid,
      start: const GridPosition(0, 0),
      exit: const GridPosition(5, 5),
      initialEnergy: 60,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.apprentice,
      storyLore: 'An ancient archway opens into damp dungeon air. The first trial awaits.',
    );
  }

  /// Helper to parse symbolic ASCII dungeon maps.
  /// '.' = floor (1)
  /// '#' = wall (impassable)
  /// 'R' = rubble (3)
  /// 'H' = hazard (5)
  /// 'E' = exit (1)
  /// 'P' = energy pickup (+25 energy)
  /// 'T' = treasure (+150 points)
  static List<List<DungeonTile>> _parseMap(List<String> rows) {
    return rows.map((row) {
      return row.split('').map((char) {
        switch (char) {
          case '#':
            return DungeonTile.wall();
          case 'R':
            return DungeonTile.rubble(movementCost: 3);
          case 'H':
            return DungeonTile.hazard(movementCost: 5);
          case 'E':
            return DungeonTile.exit(movementCost: 1);
          case 'P':
            return DungeonTile.energyPickup(movementCost: 1, energyAmount: 25);
          case 'T':
            return DungeonTile.treasure(movementCost: 1, points: 150);
          case '.':
          default:
            return DungeonTile.floor(movementCost: 1);
        }
      }).toList();
    }).toList();
  }

  /// Level 2: Forgotten Catacombs (Apprentice, 6x6)
  static DungeonLevel get level2 {
    final rows = [
      '..#..T',
      '.##.#.',
      '..R.P.',
      '##.##.',
      'T..#..',
      '##...E',
    ];
    return DungeonLevel(
      id: 'level_2',
      name: 'Forgotten Catacombs',
      rows: 6,
      cols: 6,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(5, 5),
      initialEnergy: 65,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.apprentice,
      storyLore: 'Centuries-old sarcophagi line these dusty corridors. Rubble blocks the easy passage.',
    );
  }

  /// Level 3: Whispering Vault (Apprentice, 7x7)
  static DungeonLevel get level3 {
    final rows = [
      '....#..',
      '.##.#.T',
      '..P.R..',
      '###.##.',
      'T.#..#.',
      '..##.P.',
      '#....#E',
    ];
    return DungeonLevel(
      id: 'level_3',
      name: 'Whispering Vault',
      rows: 7,
      cols: 7,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(6, 6),
      initialEnergy: 75,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.apprentice,
      storyLore: 'Ghostly echoes resonate through vaulted chambers containing lost dwarven gold.',
    );
  }

  /// Level 4: Shadowed Chambers (Explorer, 7x7)
  static DungeonLevel get level4 {
    final rows = [
      '..#...T',
      '.#H#.#.',
      '..H..R.',
      '#.###H.',
      '.P..#H.',
      '###...#',
      'T..#..E',
    ];
    return DungeonLevel(
      id: 'level_4',
      name: 'Shadowed Chambers',
      rows: 7,
      cols: 7,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(6, 6),
      initialEnergy: 65,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.explorer,
      storyLore: 'Shadows dance against decaying stonework. Toxic acid seeps from cracked floors.',
    );
  }

  /// Level 5: The Sunken Crypt (Explorer, 8x8)
  static DungeonLevel get level5 {
    final rows = [
      '..#....T',
      '.##.##.#',
      '..P.HR..',
      '###.#H##',
      'T.#..H..',
      '..##.###',
      '.P#...R.',
      '#...#..E',
    ];
    return DungeonLevel(
      id: 'level_5',
      name: 'The Sunken Crypt',
      rows: 8,
      cols: 8,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(7, 7),
      initialEnergy: 70,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.explorer,
      storyLore: 'Murky floodwaters conceal spiked floor traps. Choose your stepping stones wisely.',
    );
  }

  /// Level 6: Serpent\'s Corridor (Explorer, 8x8)
  static DungeonLevel get level6 {
    final rows = [
      '....#..T',
      '###.#.##',
      '..R.H...',
      '.##.###.',
      '.P#...#.',
      '#.###.R.',
      '..T.#.P.',
      '###...#E',
    ];
    return DungeonLevel(
      id: 'level_6',
      name: "Serpent's Corridor",
      rows: 8,
      cols: 8,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(7, 7),
      initialEnergy: 75,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.explorer,
      storyLore: 'A coiling maze built to confuse grave robbers. Rubble choke-points drain precious stamina.',
    );
  }

  /// Level 7: The Abyssal Maze (Cryptmaster, 9x9)
  static DungeonLevel get level7 {
    final rows = [
      '..#....#T',
      '.##.##.#.',
      '..R.HH...',
      '###.##.##',
      'T...#..P.',
      '###.##.##',
      '.P..HH.R.',
      '.##.##.##',
      '#..T.#..E',
    ];
    return DungeonLevel(
      id: 'level_7',
      name: 'The Abyssal Maze',
      rows: 9,
      cols: 9,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(8, 8),
      initialEnergy: 70,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.cryptmaster,
      storyLore: 'An endless labyrinth suspended over a bottomless void. One reckless detour means doom.',
    );
  }

  /// Level 8: Dread Citadel (Cryptmaster, 9x9)
  static DungeonLevel get level8 {
    final rows = [
      '....#...T',
      '###.###.#',
      '..R.H.R..',
      '.##.#.##.',
      '.P..#..P.',
      '.##.##.#.',
      '..H.R.H..',
      '#.###.##.',
      'T...#...E',
    ];
    return DungeonLevel(
      id: 'level_8',
      name: 'Dread Citadel',
      rows: 9,
      cols: 9,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(8, 8),
      initialEnergy: 75,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.cryptmaster,
      storyLore: 'The fortress of the ancient tomb keepers. Guarded by hazardous glyphs and collapsed stone arches.',
    );
  }

  /// Level 9: The Necromancer\'s Lair (Cryptmaster, 10x10)
  static DungeonLevel get level9 {
    final rows = [
      '..#......T',
      '.##.####.#',
      '..R.HH...P',
      '###.##.###',
      'T...#....#',
      '.##.##.##.',
      '.P..HH...#',
      '###.####.#',
      '..R...#..R',
      '####....#E',
    ];
    return DungeonLevel(
      id: 'level_9',
      name: "The Necromancer's Lair",
      rows: 10,
      cols: 10,
      grid: _parseMap(rows),
      start: const GridPosition(0, 0),
      exit: const GridPosition(9, 9),
      initialEnergy: 85,
      maxEnergy: 100,
      difficulty: DungeonDifficulty.cryptmaster,
      storyLore: 'The heart of the subterranean labyrinth shown on the ancient map. Only Dijkstra’s mathematical certainty guarantees survival.',
    );
  }

  /// Returns list of all available dungeon levels in progressive order.
  static List<DungeonLevel> get allLevels => [
    level1,
    level2,
    level3,
    level4,
    level5,
    level6,
    level7,
    level8,
    level9,
  ];

  /// Returns levels belonging to a specific difficulty.
  static List<DungeonLevel> byDifficulty(DungeonDifficulty difficulty) {
    return allLevels.where((l) => l.difficulty == difficulty).toList();
  }

  /// Finds level by ID or defaults to level 1.
  static DungeonLevel getLevelById(String id) {
    return allLevels.firstWhere(
      (l) => l.id == id,
      orElse: () => level1,
    );
  }

  /// Returns the next level in progression, or null if on the final level.
  static DungeonLevel? getNextLevel(String currentId) {
    final index = allLevels.indexWhere((l) => l.id == currentId);
    if (index >= 0 && index + 1 < allLevels.length) {
      return allLevels[index + 1];
    }
    return null;
  }
}
