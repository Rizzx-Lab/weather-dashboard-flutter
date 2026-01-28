import 'package:flutter/material.dart';

class WeatherGradients {
  // Main blue gradient matching React website
  static LinearGradient getMainBlueGradient(bool isDark) {
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1e3a8a), // Blue 900
          Color(0xFF1e40af), // Blue 800
          Color(0xFF0e7490), // Cyan 700
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF3b82f6), // Blue 500
          Color(0xFF2563eb), // Blue 600
          Color(0xFF0ea5e9), // Cyan 500
        ],
      );
    }
  }

  static LinearGradient getGradientByCondition(String condition, bool isDark) {
    final baseCondition = condition.toLowerCase();

    if (isDark) {
      return _getDarkGradient(baseCondition);
    } else {
      return _getLightGradient(baseCondition);
    }
  }

  static LinearGradient _getLightGradient(String condition) {
    if (condition.contains('clear') || condition.contains('sunny')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF3b82f6), // Blue 500
          Color(0xFF2563eb), // Blue 600
          Color(0xFF0ea5e9), // Cyan 500
        ],
      );
    } else if (condition.contains('cloud')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF64748b), // Slate 500
          Color(0xFF475569), // Slate 600
          Color(0xFF334155), // Slate 700
        ],
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0ea5e9), // Cyan 500
          Color(0xFF0284c7), // Cyan 600
          Color(0xFF0369a1), // Cyan 700
        ],
      );
    } else if (condition.contains('thunderstorm')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4c1d95), // Purple 900
          Color(0xFF581c87), // Purple 800
          Color(0xFF6b21a8), // Purple 700
        ],
      );
    } else if (condition.contains('snow')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFdbeafe), // Blue 100
          Color(0xFFbfdbfe), // Blue 200
          Color(0xFF93c5fd), // Blue 300
        ],
      );
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFcbd5e1), // Slate 300
          Color(0xFFa8b3c1), // Slate 400
          Color(0xFF94a3b8), // Slate 400
        ],
      );
    } else {
      // Default: Main blue gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF3b82f6), // Blue 500
          Color(0xFF2563eb), // Blue 600
          Color(0xFF0ea5e9), // Cyan 500
        ],
      );
    }
  }

  static LinearGradient _getDarkGradient(String condition) {
    if (condition.contains('clear') || condition.contains('sunny')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1e3a8a), // Blue 900
          Color(0xFF1e40af), // Blue 800
          Color(0xFF0e7490), // Cyan 700
        ],
      );
    } else if (condition.contains('cloud')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1e293b), // Slate 800
          Color(0xFF0f172a), // Slate 900
          Color(0xFF020617), // Slate 950
        ],
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF155e75), // Cyan 800
          Color(0xFF164e63), // Cyan 900
          Color(0xFF083344), // Cyan 950
        ],
      );
    } else if (condition.contains('thunderstorm')) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF312e81), // Indigo 900
          Color(0xFF3730a3), // Indigo 800
          Color(0xFF4338ca), // Indigo 700
        ],
      );
    } else if (condition.contains('snow')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF334155), // Slate 700
          Color(0xFF475569), // Slate 600
          Color(0xFF64748b), // Slate 500
        ],
      );
    } else {
      // Default dark: Dark blue gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1e3a8a), // Blue 900
          Color(0xFF1e40af), // Blue 800
          Color(0xFF0e7490), // Cyan 700
        ],
      );
    }
  }

  static Color getTextColorForBackground(LinearGradient gradient, bool isDark) {
    // Always white for dark mode and gradients
    return Colors.white;
  }
  
  // Gradient untuk metric cards (seperti di React)
  static LinearGradient getOrangeGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFf97316), // Orange 500
        Color(0xFFea580c), // Orange 600
      ],
    );
  }
  
  static LinearGradient getEmeraldGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF10b981), // Emerald 500
        Color(0xFF059669), // Emerald 600
      ],
    );
  }
  
  static LinearGradient getPurpleGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFa855f7), // Purple 500
        Color(0xFF9333ea), // Purple 600
      ],
    );
  }
  
  static LinearGradient getCyanGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF06b6d4), // Cyan 500
        Color(0xFF0891b2), // Cyan 600
      ],
    );
  }
}