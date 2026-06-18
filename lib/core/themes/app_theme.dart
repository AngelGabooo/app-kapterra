import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de colores
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF66BB6A);
  static const Color goldCoffee = Color(0xFFD4A017);
  static const Color lightBeige = Color(0xFFF8F5F0);
  static const Color darkCoffee = Color(0xFF3E2723);
  static const Color white = Color(0xFFFFFFFF);
  static const Color alertOrange = Color(0xFFF57C00);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryGreen,
      tertiary: goldCoffee,
      surface: lightBeige,
      onSurface: darkCoffee,
      background: lightBeige,
      onBackground: darkCoffee,
    ),
    scaffoldBackgroundColor: lightBeige,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkCoffee,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkCoffee,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkCoffee,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkCoffee,
        ),
      ),
    ),
  );
}