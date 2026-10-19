import 'package:flutter/material.dart';

import '../data/sample_levels.dart';
import '../game/game_controller.dart';
import '../models/dungeon_level.dart';
import '../theme/dungeon_theme.dart';
import '../widgets/algorithm_vision_panel.dart';
import '../widgets/dungeon_board.dart';
import '../widgets/movement_controls.dart';
import 'results_screen.dart';

/// Complete, playable dungeon exploration screen with integrated
/// Algorithm Vision for Dijkstra shortest-path observation, enhanced with
/// suspenseful torchlight ambiance and multi-level progression.
class DungeonScreen extends StatefulWidget {
  final GameController? controller;
  final DungeonLevel? initialLevel;
  final bool startWithVision;

  const DungeonScreen({
    super.key,
    this.controller,
    this.initialLevel,
    this.startWithVision = false,
  });

  @override
  State<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends State<DungeonScreen> {
  late GameController _controller;
  bool _ownsController = false;
  bool _hasNavigatedToResults = false;
  bool _torchlightMode = true; // Suspense mode on by default

  @override
  void initState() {
    super.initState();
    _setupController(widget.initialLevel ?? SampleLevels.level1);

    if (widget.startWithVision) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_controller.isShowingAlgorithm) {
          _controller.startAlgorithmVision();
        }
      });
    }
  }

  void _setupController(DungeonLevel level) {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = GameController(level: level);
      _ownsController = true;
    }
    _controller.addListener(_handleGameStateChange);
  }

  void _switchLevel(DungeonLevel newLevel) {
    _controller.removeListener(_handleGameStateChange);
    if (_ownsController) {
      _controller.dispose();
    }
    setState(() {
      _hasNavigatedToResults = false;
      _controller = GameController(level: newLevel);
      _ownsController = true;
      _controller.addListener(_handleGameStateChange);
    });
  }

  void _handleGameStateChange() {
    if (!mounted) return;
    if ((_controller.isWon || _controller.isLost) && !_hasNavigatedToResults) {
      _hasNavigatedToResults = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _navigateToResults();
      });
    } else if (!_controller.isWon && !_controller.isLost) {
      _hasNavigatedToResults = false;
    }
  }

  void _navigateToResults() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          controller: _controller,
          onReplay: () {
            Navigator.of(context).pop();
            _controller.restartLevel();
          },
          onNextLevel: () {
            Navigator.of(context).pop();
            final nextLvl = SampleLevels.getNextLevel(_controller.level.id);
            if (nextLvl != null) {
              _switchLevel(nextLvl);
            }
          },
          onMainMenu: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  void _showChamberSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF140F0A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Color(0xFF8C6D46), width: 1.5),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.map_rounded, color: Color(0xFFF59E0B), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'DUNGEON CHAMBERS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFFFEF3C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: SampleLevels.allLevels.length,
                    itemBuilder: (context, index) {
                      final lvl = SampleLevels.allLevels[index];
                      final isCurrent = lvl.id == _controller.level.id;
                      return ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: isCurrent
                            ? const Color(0xFF2E2012)
                            : Colors.transparent,
                        title: Text(
                          lvl.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent ? const Color(0xFFFCD34D) : const Color(0xFFD4C3A3),
                          ),
                        ),
                        subtitle: Text(
                          '${lvl.difficulty.displayName} • ${lvl.rows}x${lvl.cols} • ⚡${lvl.initialEnergy}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF8C7355)),
                        ),
                        trailing: isCurrent
                            ? const Icon(Icons.check_circle_rounded, color: Color(0xFFF59E0B), size: 18)
                            : null,
                        onTap: () {
                          Navigator.of(context).pop();
                          _switchLevel(lvl);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleGameStateChange);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: DungeonTheme.abyssBlack,
          appBar: AppBar(
            backgroundColor: const Color(0xFF140F0A),
            foregroundColor: Colors.white,
            elevation: 4,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _controller.level.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDE68A),
                  ),
                ),
                Text(
                  '${_controller.level.difficulty.displayName} Chamber • ${_controller.level.rows}x${_controller.level.cols}',
                  style: const TextStyle(fontSize: 10, color: Color(0xFFB49A76)),
                ),
              ],
            ),
            actions: [
              // Torchlight / Fog of War toggle
              IconButton(
                icon: Icon(
                  _torchlightMode
                      ? Icons.local_fire_department_rounded
                      : Icons.wb_sunny_outlined,
                  color: _torchlightMode ? const Color(0xFFF59E0B) : Colors.white60,
                ),
                tooltip: _torchlightMode ? 'Torchlight Active (Tap to Reveal All)' : 'Reveal Active (Tap for Suspense Fog)',
                onPressed: () {
                  setState(() => _torchlightMode = !_torchlightMode);
                },
              ),
              // Chambers selection
              IconButton(
                icon: const Icon(Icons.layers_outlined),
                tooltip: 'Select Chamber',
                onPressed: _showChamberSelector,
              ),
              IconButton(
                icon: Icon(
                  _controller.isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                ),
                tooltip: _controller.isPaused ? 'Resume' : 'Pause',
                onPressed: _controller.isWon || _controller.isLost
                    ? null
                    : () {
                        if (_controller.isPaused) {
                          _controller.resume();
                        } else {
                          _controller.pause();
                        }
                      },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt_rounded),
                tooltip: 'Restart Level',
                onPressed: () => _controller.restartLevel(),
              ),
            ],
          ),
          body: Stack(
            children: [
              // Atmospheric background parchment
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      _buildStatsCard(),
                      const SizedBox(height: 8),
                      if (_controller.isWon)
                        _buildVictoryBanner()
                      else if (_controller.isLost)
                        _buildLossBanner()
                      else if (_controller.isPaused)
                        _buildPausedBanner()
                      else if (_controller.lastRejectionReason != null)
                        _buildRejectionBanner(),
                      const SizedBox(height: 8),

                      // Dungeon Board with optional Algorithm Vision overlays & torchlight
                      ListenableBuilder(
                        listenable: _controller.visualizationController,
                        builder: (context, _) {
                          return DungeonBoard(
                            level: _controller.level,
                            playerState: _controller.playerState,
                            visualizationState:
                                _controller.visualizationController.state,
                            torchlightMode: _torchlightMode,
                          );
                        },
                      ),
                      const SizedBox(height: 8),

                      // Interactive controls: Algorithm Vision panel or manual controls
                      if (_controller.isShowingAlgorithm)
                        AlgorithmVisionPanel(controller: _controller)
                      else ...[
                        _buildLegend(),
                        const SizedBox(height: 8),
                        _buildVisionLaunchButton(),
                        const SizedBox(height: 8),
                        MovementControls(controller: _controller),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVisionLaunchButton() {
    final canLaunch =
        !_controller.isWon && !_controller.isLost && !_controller.isPaused;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.visibility_rounded, size: 18),
        label: const Text('Algorithm Vision'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
          foregroundColor: const Color(0xFFDDD6FE),
          backgroundColor: const Color(0xFF1F152E).withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: canLaunch ? () => _controller.startAlgorithmVision() : null,
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF735635).withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.bolt_rounded,
            iconColor: const Color(0xFFFCD34D),
            label: 'Energy',
            value: '${_controller.currentEnergy}/${_controller.maxEnergy}',
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.directions_walk_rounded,
            iconColor: const Color(0xFF38BDF8),
            label: 'Moves',
            value: '${_controller.moveCount}',
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.speed_rounded,
            iconColor: const Color(0xFF34D399),
            label: 'Route Cost',
            value: '${_controller.cumulativeRouteCost}',
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFF59E0B),
            label: 'Score',
            value: '${_controller.score}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFBEB),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFFB49A76)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 1, color: const Color(0xFF4A3824));
  }

  Widget _buildVictoryBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2E23),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF10B981)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Labyrinth Escaped! Victory!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
                Text(
                  'Moves: ${_controller.moveCount} • Cumulative Cost: ${_controller.cumulativeRouteCost} • Score: ${_controller.score}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD1FAE5),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _navigateToResults,
            child: const Text('Results', style: TextStyle(color: Color(0xFF6EE7B7))),
          ),
          TextButton(
            onPressed: () => _controller.restartLevel(),
            child: const Text('Replay', style: TextStyle(color: Color(0xFFFCD34D))),
          ),
        ],
      ),
    );
  }

  Widget _buildLossBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF381212),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEF4444)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Energy Depleted! The explorer could not escape.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFFCA5A5),
              ),
            ),
          ),
          TextButton(
            onPressed: _navigateToResults,
            child: const Text('Results', style: TextStyle(color: Color(0xFFFCA5A5))),
          ),
          TextButton(
            onPressed: () => _controller.restartLevel(),
            child: const Text('Retry', style: TextStyle(color: Color(0xFFFCD34D))),
          ),
        ],
      ),
    );
  }

  Widget _buildPausedBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2012),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pause_circle_filled_rounded,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
          const SizedBox(width: 8),
          const Text(
            'Game Paused',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFFFDE68A),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () => _controller.resume(),
            child: const Text('Resume', style: TextStyle(color: Color(0xFFFCD34D))),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEA580C)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Color(0xFFFB923C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _controller.lastRejectionReason!,
              style: const TextStyle(fontSize: 11, color: Color(0xFFFDBA74)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6B5135).withValues(alpha: 0.4)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: [
          _buildLegendItem('Floor', '1', const Color(0xFFD4C3A3)),
          _buildLegendItem('Rubble', '3', const Color(0xFFF59E0B)),
          _buildLegendItem('Hazard', '5', const Color(0xFFEF4444)),
          _buildLegendIcon('Wall', Icons.grid_4x4, const Color(0xFF8C7355)),
          _buildLegendIcon(
            'Exit',
            Icons.vpn_key_rounded,
            const Color(0xFFC084FC),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String cost, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            cost,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFFB49A76)),
        ),
      ],
    );
  }

  Widget _buildLegendIcon(String label, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFFB49A76)),
        ),
      ],
    );
  }
}
