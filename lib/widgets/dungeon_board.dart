import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/dungeon_level.dart';
import '../models/dungeon_tile.dart';
import '../models/grid_position.dart';
import '../models/player_state.dart';
import '../models/visualization_state.dart';
import '../theme/dungeon_theme.dart';

/// Responsive grid board displaying the labyrinth tiles, obstacles, player,
/// and optional Algorithm Vision exploration overlays with antique parchment
/// and suspenseful torchlight aesthetics.
class DungeonBoard extends StatelessWidget {
  final DungeonLevel level;
  final PlayerState playerState;
  final VisualizationState? visualizationState;
  final bool torchlightMode;

  const DungeonBoard({
    super.key,
    required this.level,
    required this.playerState,
    this.visualizationState,
    this.torchlightMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDimension = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        final double boardSize = maxDimension.clamp(240.0, 420.0);

        return Center(
          child: Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              color: DungeonTheme.abyssBlack,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: DungeonTheme.torchAmber.withValues(alpha: 0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: DungeonTheme.torchAmber.withValues(alpha: 0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  // Underlying parchment texture
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.22,
                      child: Image.asset(
                        'assets/images/parchment_map.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: DungeonTheme.parchmentPaper,
                        ),
                      ),
                    ),
                  ),

                  // Grid Cells
                  Column(
                    children: List.generate(level.rows, (r) {
                      return Expanded(
                        child: Row(
                          children: List.generate(level.cols, (c) {
                            final pos = GridPosition(r, c);
                            final tile = level.tileAt(pos);
                            final isPlayerHere = playerState.position == pos;
                            final isCollected = playerState.collectedItemIds.contains(
                              'item_${r}_$c',
                            );

                            final isFrontier =
                                visualizationState?.frontierNodes.contains(pos) ??
                                false;
                            final isSettled =
                                visualizationState?.settledNodes.contains(pos) ??
                                false;
                            final isFinalPath =
                                visualizationState?.finalPath.contains(pos) ?? false;
                            final cellDistance =
                                visualizationState?.nodeDistances[pos];

                            // Torchlight distance calculation
                            final dx = (c - playerState.position.col).toDouble();
                            final dy = (r - playerState.position.row).toDouble();
                            final distFromPlayer = math.sqrt(dx * dx + dy * dy);

                            return Expanded(
                              child: _buildTileCell(
                                pos: pos,
                                tile: tile,
                                isPlayerHere: isPlayerHere,
                                isCollected: isCollected,
                                isFrontier: isFrontier,
                                isSettled: isSettled,
                                isFinalPath: isFinalPath,
                                cellDistance: cellDistance,
                                distFromPlayer: distFromPlayer,
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTileCell({
    required GridPosition pos,
    required DungeonTile tile,
    required bool isPlayerHere,
    required bool isCollected,
    required bool isFrontier,
    required bool isSettled,
    required bool isFinalPath,
    required int? cellDistance,
    required double distFromPlayer,
  }) {
    Color backgroundColor;
    Widget? terrainContent;

    switch (tile.type) {
      case TileType.wall:
        backgroundColor = const Color(0xFF1B1612);
        terrainContent = Icon(
          Icons.grid_4x4_rounded,
          size: 14,
          color: const Color(0xFF4A3B2C).withValues(alpha: 0.7),
        );
        break;

      case TileType.rubble:
        backgroundColor = const Color(0xFFEAD9B8);
        terrainContent = Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.landscape_rounded,
              size: 20,
              color: const Color(0xFFB08953).withValues(alpha: 0.4),
            ),
            const Text(
              '3',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A5A20),
              ),
            ),
          ],
        );
        break;

      case TileType.hazard:
        backgroundColor = const Color(0xFF451919);
        terrainContent = const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: Color(0xFFE53E3E),
            ),
            Text(
              '5',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
        break;

      case TileType.exit:
        backgroundColor = const Color(0xFF2E1A47);
        terrainContent = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: DungeonTheme.runeArcane.withValues(alpha: 0.6),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.vpn_key_rounded,
            size: 16,
            color: Color(0xFFC084FC),
          ),
        );
        break;

      case TileType.floor:
        backgroundColor = const Color(0xFFF4EAD4);
        break;
    }

    // Border and overlay styling for Algorithm Vision
    Color borderColor = const Color(0xFF8C7355).withValues(alpha: 0.35);
    double borderWidth = 0.5;
    Color overlayColor = Colors.transparent;

    if (tile.type != TileType.wall) {
      if (isFinalPath) {
        borderColor = DungeonTheme.torchGlow;
        borderWidth = 2.0;
        overlayColor = DungeonTheme.torchAmber.withValues(alpha: 0.35);
      } else if (isSettled) {
        borderColor = const Color(0xFF818CF8);
        borderWidth = 1.0;
        overlayColor = const Color(0x336366F1);
      } else if (isFrontier) {
        borderColor = const Color(0xFFF59E0B);
        borderWidth = 1.5;
        overlayColor = const Color(0x3DF59E0B);
      }
    }

    // Optional uncollected items
    Widget? itemIcon;
    if (!isCollected) {
      if (tile.collectible == CollectibleType.energy) {
        itemIcon = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: DungeonTheme.energyCyan.withValues(alpha: 0.6),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.bolt_rounded,
            size: 16,
            color: Color(0xFF38BDF8),
          ),
        );
      } else if (tile.collectible == CollectibleType.treasure) {
        itemIcon = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: DungeonTheme.torchGlow.withValues(alpha: 0.7),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.diamond_rounded,
            size: 15,
            color: Color(0xFFFFD166),
          ),
        );
      }
    }

    // Suspense Fog of War calculation
    final bool isShrouded = torchlightMode &&
        distFromPlayer > 2.4 &&
        !isPlayerHere &&
        !isFinalPath &&
        !isSettled &&
        !isFrontier;

    final double shroudOpacity = isShrouded
        ? (distFromPlayer > 3.4 ? 0.94 : 0.65)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base terrain content
          if (terrainContent != null) terrainContent,

          // Algorithm Vision overlay tint
          if (overlayColor != Colors.transparent)
            Container(color: overlayColor),

          // Distance badge for explored nodes
          if (cellDistance != null &&
              (isSettled || isFrontier) &&
              tile.type != TileType.wall)
            Positioned(
              top: 1,
              left: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.5,
                  vertical: 0.5,
                ),
                decoration: BoxDecoration(
                  color: isSettled
                      ? const Color(0xFF4338CA)
                      : const Color(0xFFB45309),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  '$cellDistance',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ),

          // Final path route indicator (when not occupied by player or exit)
          if (isFinalPath && !isPlayerHere && tile.type != TileType.exit)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: DungeonTheme.torchGlow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xAAF59E0B),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),

          // Item icon
          if (itemIcon != null) itemIcon,

          // Player icon with suspense torchlight halo
          if (isPlayerHere)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFC2410C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFDE047), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xDDF59E0B),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Color(0x99FF8800),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                size: 16,
                color: Color(0xFFFFFBEB),
              ),
            ),

          // Suspense Fog of War shroud overlay
          if (isShrouded)
            Container(
              color: Color.fromRGBO(15, 12, 9, shroudOpacity),
            ),
        ],
      ),
    );
  }
}
