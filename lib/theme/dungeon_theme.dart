import 'package:flutter/material.dart';

/// Central theme definitions for the Suspense & Antique Parchment aesthetic.
class DungeonTheme {
  // Deep Dungeon & Abyssal Tones
  static const Color abyssBlack = Color(0xFF0F0C09);
  static const Color abyssSurface = Color(0xFF191410);
  static const Color abyssCard = Color(0xFF221B15);
  static const Color abyssBorder = Color(0xFF3E3125);

  // Antique Weathered Parchment Tones (from the map)
  static const Color parchmentPaper = Color(0xFFF3E7D0);
  static const Color parchmentDark = Color(0xFFE2D1B2);
  static const Color parchmentAged = Color(0xFFD0BA92);
  static const Color parchmentBorder = Color(0xFF8A6B47);
  static const Color parchmentInk = Color(0xFF2D2015);
  static const Color parchmentSubtext = Color(0xFF6B533E);

  // Atmospheric Torch & Magical Accents
  static const Color torchAmber = Color(0xFFF59E0B);
  static const Color torchEmber = Color(0xFFEA580C);
  static const Color torchGlow = Color(0xFFFFB703);
  static const Color runeArcane = Color(0xFF8B5CF6);
  static const Color hazardCrimson = Color(0xFFB91C1C);
  static const Color hazardBg = Color(0xFF381212);
  static const Color energyCyan = Color(0xFF0EA5E9);
  static const Color treasureGold = Color(0xFFD97706);
  static const Color victoryJade = Color(0xFF10B981);

  // Stone & Wall Tones
  static const Color wallStone = Color(0xFF1A1511);
  static const Color wallStoneBorder = Color(0xFF342A22);

  /// Background with the uploaded parchment map image layered under atmospheric vignette.
  static BoxDecoration suspenseBackground({bool showMap = true}) {
    return BoxDecoration(
      color: abyssBlack,
      image: showMap
          ? const DecorationImage(
              image: AssetImage('assets/images/parchment_map.jpg'),
              fit: BoxFit.cover,
              opacity: 0.18,
            )
          : null,
    );
  }

  /// Antique parchment scroll card decoration.
  static BoxDecoration parchmentCard({
    Color? border,
    double borderWidth = 1.5,
    double borderRadius = 14,
  }) {
    return BoxDecoration(
      color: parchmentPaper,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: border ?? parchmentBorder.withValues(alpha: 0.6),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  /// Dark atmospheric crypt card decoration.
  static BoxDecoration cryptCard({
    Color? border,
    double borderWidth = 1.2,
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      color: abyssCard,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: border ?? abyssBorder,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
