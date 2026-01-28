import 'package:flutter/material.dart';

class CustomTheme {
  // React website colors
  static const Color darkBackground = Color(0xFF1a1d29); // Navy blue dark
  static const Color darkCard = Color(0xFF242936); // Dark card color
  static const Color darkBorder = Color(0xFF2d3142);
  static const Color blueAccent = Color(0xFF3b82f6); // Blue gradient primary
  static const Color cyanAccent = Color(0xFF06b6d4); // Cyan accent
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    
    primarySwatch: Colors.blue,
    primaryColor: blueAccent,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    
    cardColor: Colors.white,
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: blueAccent,
    scaffoldBackgroundColor: darkBackground, // Match React
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    
    cardColor: darkCard, // Match React card color
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
  
  // Helper untuk gradient colors
  static LinearGradient getBlueGradient() {
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
  
  static LinearGradient getDarkBlueGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1e3a8a), // Dark Blue 900
        Color(0xFF1e40af), // Blue 800
        Color(0xFF0e7490), // Cyan 700
      ],
    );
  }
}