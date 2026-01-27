import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    // Nonaktifkan Material 3 untuk kompatibilitas
    useMaterial3: false,
    
    // Warna dasar
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
    
    // Card Theme - HAPUS const dan gunakan properti dasar
    cardColor: Colors.white,
    // JANGAN gunakan cardTheme, pakai cara alternatif
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1976D2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    // Nonaktifkan Material 3
    useMaterial3: false,
    
    // Dark mode settings
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    // AppBar Theme untuk dark mode
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    
    // Card Theme untuk dark mode
    cardColor: const Color(0xFF2D2D2D),
    // JANGAN gunakan cardTheme
    
    // Elevated Button Theme untuk dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1976D2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}