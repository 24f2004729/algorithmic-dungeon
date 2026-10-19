import 'package:flutter/material.dart';

import '../game/direction.dart';
import '../game/game_controller.dart';
import '../theme/dungeon_theme.dart';

/// Large, accessible directional movement pad for navigating the dungeon
/// with gothic stone and torchlight styling.
class MovementControls extends StatelessWidget {
  final GameController controller;

  const MovementControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool canMove =
        !controller.isWon && !controller.isLost && !controller.isPaused;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF16110D).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6B5135).withValues(alpha: 0.4),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: 190,
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Up Button
              _buildDirectionButton(
                context: context,
                direction: Direction.up,
                icon: Icons.keyboard_arrow_up_rounded,
                enabled: canMove,
              ),
              const SizedBox(height: 6),
              // Middle Row: Left, Center spacer, Right
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDirectionButton(
                    context: context,
                    direction: Direction.left,
                    icon: Icons.keyboard_arrow_left_rounded,
                    enabled: canMove,
                  ),
                  const SizedBox(width: 48),
                  _buildDirectionButton(
                    context: context,
                    direction: Direction.right,
                    icon: Icons.keyboard_arrow_right_rounded,
                    enabled: canMove,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Down Button
              _buildDirectionButton(
                context: context,
                direction: Direction.down,
                icon: Icons.keyboard_arrow_down_rounded,
                enabled: canMove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton({
    required BuildContext context,
    required Direction direction,
    required IconData icon,
    required bool enabled,
  }) {
    return SizedBox(
      width: 48,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: enabled
              ? const Color(0xFF261D15)
              : const Color(0xFF18130E),
          foregroundColor: enabled
              ? DungeonTheme.torchAmber
              : const Color(0xFF5E4833),
          elevation: enabled ? 3 : 0,
          shadowColor: DungeonTheme.torchAmber.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: enabled
                  ? const Color(0xFFB45309).withValues(alpha: 0.7)
                  : const Color(0xFF382718),
              width: 1.2,
            ),
          ),
        ),
        onPressed: enabled ? () => controller.move(direction) : null,
        child: Icon(icon, size: 26),
      ),
    );
  }
}
