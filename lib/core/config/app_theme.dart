import 'package:flutter/material.dart';

// Provides light and dark mode themes [cite: 24]
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}