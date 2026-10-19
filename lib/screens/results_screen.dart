import 'package:flutter/material.dart';

import '../data/sample_levels.dart';
import '../game/game_controller.dart';
import '../theme/dungeon_theme.dart';

/// Screen presenting comprehensive run statistics, path comparisons,
/// and next level progression actions upon dungeon completion or defeat,
/// styled with the antique parchment and suspense aesthetic.
class ResultsScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback? onReplay;
  final VoidCallback? onNextLevel;
  final VoidCallback? onMainMenu;

  const ResultsScreen({
    super.key,
    required this.controller,
    this.onReplay,
    this.onNextLevel,
    this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    final isVictory = controller.isWon;
    final primaryAccent = isVictory
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    final headerBg = isVictory
        ? const Color(0xFF0F2E23)
        : const Color(0xFF381212);

    final nextLevel = SampleLevels.getNextLevel(controller.level.id);

    return Scaffold(
      backgroundColor: DungeonTheme.abyssBlack,
      appBar: AppBar(
        title: Text(
          isVictory ? 'Mission Complete' : 'Run Over',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFDE68A)),
        ),
        backgroundColor: const Color(0xFF140F0A),
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back to Dungeon',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background parchment texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/images/parchment_map.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: DungeonTheme.abyssBlack),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Outcome Banner
                      _buildOutcomeHeader(isVictory, primaryAccent, headerBg),
                      const SizedBox(height: 16),

                      // Route Cost & Dijkstra Comparison (Core Academic Feature)
                      _buildPathComparisonCard(context),
                      const SizedBox(height: 16),

                      // Run Statistics Card
                      _buildRunStatisticsCard(),
                      const SizedBox(height: 20),

                      // Primary Navigation Actions
                      _buildActionButtons(context, isVictory, nextLevel != null),
                      const SizedBox(height: 16),

                      // Academic Project Footer
                      const Text(
                        'PCCOE IT • DAA Academic Project\nShortest Path Exploration with Dijkstra Engine',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8C7355),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomeHeader(
    bool isVictory,
    Color primaryAccent,
    Color headerBg,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryAccent.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryAccent.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryAccent.withValues(alpha: 0.2),
              border: Border.all(color: primaryAccent, width: 2),
            ),
            child: Icon(
              isVictory ? Icons.emoji_events_rounded : Icons.dangerous_rounded,
              size: 40,
              color: primaryAccent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isVictory ? 'Labyrinth Escaped!' : 'Defeat: Energy Depleted',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryAccent,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            isVictory
                ? 'You navigated the treacherous chamber "${controller.level.name}" and reached the mystical exit portal.'
                : 'Your stamina ran out before escaping "${controller.level.name}". Review the Dijkstra optimal route to plan your next attempt.',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFD4C3A3),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPathComparisonCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8C6D46).withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.compare_arrows_rounded,
                size: 20,
                color: Color(0xFFF59E0B),
              ),
              SizedBox(width: 8),
              Text(
                'Route Cost Comparison',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFEF3C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Player actual cost
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF261D15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF5A442E)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Actual Route Cost',
                        style: TextStyle(fontSize: 11, color: Color(0xFFB49A76)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${controller.cumulativeRouteCost}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFCD34D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Dijkstra optimal cost
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF261D15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF5A442E)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Optimal Dijkstra Cost',
                        style: TextStyle(fontSize: 11, color: Color(0xFFB49A76)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${controller.optimalRouteCost}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Route Efficiency metric
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF140F0A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4A3824)),
            ),
            child: Center(
              child: Text(
                controller.routeEfficiency >= 99.9
                    ? 'Route Efficiency: 100.0% (Optimal! 🏆)'
                    : 'Route Efficiency: ${controller.routeEfficiency.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: controller.routeEfficiency >= 99.9
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunStatisticsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8C6D46).withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 20,
                color: Color(0xFFF59E0B),
              ),
              SizedBox(width: 8),
              Text(
                'Run Breakdown',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFEF3C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMetricRow(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF59E0B),
            label: 'Final Score',
            value: '${controller.score} pts',
          ),
          const Divider(height: 16, color: Color(0xFF38291C)),
          _buildMetricRow(
            icon: Icons.bolt_rounded,
            iconColor: const Color(0xFFFCD34D),
            label: 'Remaining Energy',
            value: '${controller.currentEnergy} / ${controller.maxEnergy}',
          ),
          const Divider(height: 16, color: Color(0xFF38291C)),
          _buildMetricRow(
            icon: Icons.directions_walk_rounded,
            iconColor: const Color(0xFF38BDF8),
            label: 'Steps / Moves Taken',
            value: '${controller.moveCount}',
          ),
          const Divider(height: 16, color: Color(0xFF38291C)),
          _buildMetricRow(
            icon: Icons.diamond_outlined,
            iconColor: const Color(0xFF34D399),
            label: 'Treasures Collected',
            value: '${controller.collectedTreasuresCount}',
          ),
          const Divider(height: 16, color: Color(0xFF38291C)),
          _buildMetricRow(
            icon: Icons.visibility_outlined,
            iconColor: const Color(0xFFA78BFA),
            label: 'Algorithm Vision Hints Used',
            value: '${controller.hintUsageCount}',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFD4C3A3),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFBEB),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isVictory, bool hasNextLevel) {
    return Column(
      children: [
        // Next Level Button (shown on victory if another chamber exists)
        if (isVictory && hasNextLevel) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF6EE7B7), width: 1.5),
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 22),
              label: const Text(
                'Next Chamber',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (onNextLevel != null) {
                  onNextLevel!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Replay Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB45309),
              foregroundColor: const Color(0xFFFFFBEB),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFFCD34D), width: 1.2),
              ),
            ),
            icon: const Icon(Icons.replay_rounded, size: 22),
            label: const Text(
              'Replay Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (onReplay != null) {
                onReplay!();
              } else {
                controller.restartLevel();
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        const SizedBox(height: 10),

        // Main Menu Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF6B5135), width: 1.5),
              foregroundColor: const Color(0xFFD4C3A3),
              backgroundColor: const Color(0xFF1E1710),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.home_rounded, size: 20),
            label: const Text(
              'Main Menu',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              if (onMainMenu != null) {
                onMainMenu!();
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ),
      ],
    );
  }
}
