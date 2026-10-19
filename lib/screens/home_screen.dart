import 'package:flutter/material.dart';

import '../data/sample_levels.dart';
import '../models/dungeon_level.dart';
import '../theme/dungeon_theme.dart';
import 'dungeon_screen.dart';

/// Suspenseful, antique parchment-themed Home Screen with multi-tier difficulty
/// selection and level browser.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DungeonDifficulty _selectedDifficulty = DungeonDifficulty.apprentice;
  late DungeonLevel _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = SampleLevels.level1;
  }

  void _onDifficultyChanged(DungeonDifficulty diff) {
    setState(() {
      _selectedDifficulty = diff;
      final levelsInDiff = SampleLevels.byDifficulty(diff);
      if (!levelsInDiff.any((l) => l.id == _selectedLevel.id)) {
        _selectedLevel = levelsInDiff.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelsForTier = SampleLevels.byDifficulty(_selectedDifficulty);

    return Scaffold(
      backgroundColor: DungeonTheme.abyssBlack,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 20),
            SizedBox(width: 8),
            Text(
              'Algorithmic Dungeon',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Color(0xFFFDE68A),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF140F0A),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Parchment Texture with Vignette
          Positioned.fill(
            child: Opacity(
              opacity: 0.28,
              child: Image.asset(
                'assets/images/parchment_map.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: DungeonTheme.abyssBlack,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    DungeonTheme.abyssBlack.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Emblem with Torchfire
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: const Color(0xFF221810),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: DungeonTheme.torchAmber.withValues(alpha: 0.7),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: DungeonTheme.torchAmber.withValues(alpha: 0.3),
                              blurRadius: 18,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          size: 44,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Ornamental Flourish
                      const Text(
                        '✦ ── ✧ ── ✦',
                        style: TextStyle(
                          color: Color(0xFFD97706),
                          fontSize: 12,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Main Title
                      Text(
                        'Algorithmic Dungeon',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFEF3C7),
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Escape the Labyrinth • DAA Academic Project',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD4C3A3),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Difficulty Selector Tabs
                      _buildDifficultySelector(),
                      const SizedBox(height: 16),

                      // Level Browser Cards
                      _buildLevelBrowser(levelsForTier),
                      const SizedBox(height: 20),

                      // Primary Play Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB45309),
                            foregroundColor: const Color(0xFFFFFBEB),
                            elevation: 4,
                            shadowColor: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFFFCD34D),
                                width: 1.5,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 26),
                          label: const Text(
                            'Start Game',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DungeonScreen(
                                  initialLevel: _selectedLevel,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Algorithm Vision Demo Button
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF8B5CF6),
                              width: 1.5,
                            ),
                            foregroundColor: const Color(0xFFDDD6FE),
                            backgroundColor: const Color(0xFF1E142B).withValues(alpha: 0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.visibility_rounded, size: 20, color: Color(0xFFA78BFA)),
                          label: const Text(
                            'Algorithm Vision Demo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DungeonScreen(
                                  initialLevel: _selectedLevel,
                                  startWithVision: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // How to Play Parchment Card
                      _buildHowToPlayCard(),
                      const SizedBox(height: 20),

                      // Academic Credits Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A140F).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF785938).withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Design & Analysis of Algorithms • FA2 Project',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFDE68A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Pimpri Chinchwad College of Engineering (PCCOE), Pune\nDepartment of Information Technology',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFD4C3A3),
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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

  Widget _buildDifficultySelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17120C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A3824)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: DungeonDifficulty.values.map((diff) {
          final isSelected = _selectedDifficulty == diff;
          Color activeColor;
          IconData icon;
          switch (diff) {
            case DungeonDifficulty.apprentice:
              activeColor = const Color(0xFF10B981);
              icon = Icons.shield_outlined;
              break;
            case DungeonDifficulty.explorer:
              activeColor = const Color(0xFFF59E0B);
              icon = Icons.explore_outlined;
              break;
            case DungeonDifficulty.cryptmaster:
              activeColor = const Color(0xFFEF4444);
              icon = Icons.dangerous_outlined;
              break;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => _onDifficultyChanged(diff),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.22)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: activeColor, width: 1.5)
                      : Border.all(color: Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: isSelected ? activeColor : const Color(0xFF8C7355),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      diff.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFFA8957A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLevelBrowser(List<DungeonLevel> levels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHOOSE LABYRINTH (${_selectedDifficulty.displayName.toUpperCase()})',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Color(0xFFF59E0B),
                ),
              ),
              Text(
                '${levels.length} Chambers',
                style: const TextStyle(fontSize: 11, color: Color(0xFF8C7355)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...levels.map((lvl) {
          final isChosen = _selectedLevel.id == lvl.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => setState(() => _selectedLevel = lvl),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isChosen
                      ? const Color(0xFF2A1F14)
                      : const Color(0xFF19130D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isChosen
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF3D2C1B),
                    width: isChosen ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isChosen
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
                            : Colors.black26,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isChosen
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF5A442E),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${lvl.rows}x${lvl.cols}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isChosen ? const Color(0xFFFCD34D) : const Color(0xFF8C7355),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lvl.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isChosen ? FontWeight.bold : FontWeight.w600,
                              color: isChosen ? const Color(0xFFFFFBEB) : const Color(0xFFD4C3A3),
                            ),
                          ),
                          if (lvl.storyLore != null)
                            Text(
                              lvl.storyLore!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF948067),
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF130E09),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF4A3824)),
                      ),
                      child: Text(
                        '⚡ ${lvl.initialEnergy}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFCD34D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHowToPlayCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF8C6D46).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.explore_outlined,
                  size: 20,
                  color: Color(0xFFF59E0B),
                ),
                SizedBox(width: 8),
                Text(
                  'How to Play',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFEF3C7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '• Navigate through the weighted labyrinth to the Exit portal.\n'
              '• Normal floors cost 1 energy. Rubble costs 3 energy.\n'
              '• Hazardous terrain costs 5 energy. Walls are blocked.\n'
              '• Shorter routes in steps may cost more energy than longer paths!\n'
              '• Collect energy canisters to restore movement power.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFFD4C3A3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
