import 'package:flutter/material.dart';

class WeatherGradients {
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
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF87CEEB), // Sky blue
          const Color(0xFF4A90E2), // Ocean blue
          const Color(0xFF1E88E5), // Deep blue
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else if (condition.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFB0BEC5), // Light gray
          const Color(0xFF78909C), // Medium gray
          const Color(0xFF546E7A), // Dark gray
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF90A4AE),
          const Color(0xFF607D8B),
          const Color(0xFF455A64),
        ],
        stops: const [0.0, 0.6, 1.0],
      );
    } else if (condition.contains('thunderstorm')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF263238),
          const Color(0xFF37474F),
          const Color(0xFF102027),
        ],
      );
    } else if (condition.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFE3F2FD),
          const Color(0xFFBBDEFB),
          const Color(0xFF90CAF9),
        ],
      );
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFCFD8DC),
          const Color(0xFFB0BEC5),
          const Color(0xFF90A4AE),
        ],
      );
    } else {
      // Default gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF2196F3),
          const Color(0xFF03A9F4),
          const Color(0xFF00BCD4),
        ],
      );
    }
  }

  static LinearGradient _getDarkGradient(String condition) {
    if (condition.contains('clear') || condition.contains('sunny')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0D47A1),
          const Color(0xFF1565C0),
          const Color(0xFF1976D2),
        ],
      );
    } else if (condition.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF37474F),
          const Color(0xFF263238),
          const Color(0xFF102027),
        ],
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF37474F),
          const Color(0xFF2C3E50),
          const Color(0xFF1C2833),
        ],
      );
    } else if (condition.contains('thunderstorm')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A237E),
          const Color(0xFF283593),
          const Color(0xFF303F9F),
        ],
      );
    } else if (condition.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF37474F),
          const Color(0xFF455A64),
          const Color(0xFF546E7A),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A237E),
          const Color(0xFF283593),
          const Color(0xFF303F9F),
        ],
      );
    }
  }

  static Color getTextColorForBackground(LinearGradient gradient, bool isDark) {
    if (isDark) {
      return Colors.white;
    }
    
    // For light mode, check if gradient is dark
    final colors = gradient.colors;
    if (colors.isNotEmpty) {
      final firstColor = colors[0];
      final brightness = (firstColor.red * 299 + firstColor.green * 587 + firstColor.blue * 114) / 1000;
      return brightness > 128 ? Colors.black87 : Colors.white;
    }
    return Colors.black87;
  }
}