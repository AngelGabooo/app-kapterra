import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🟢 Paleta de colores ORIGINAL
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF66BB6A);
  static const Color goldCoffee = Color(0xFFD4A017);
  static const Color lightBeige = Color(0xFFF8F5F0);
  static const Color darkCoffee = Color(0xFF3E2723);
  static const Color white = Color(0xFFFFFFFF);
  static const Color alertOrange = Color(0xFFF57C00);

  // 🆕 Colores para Dark Theme (Café)
  static const Color coffeeDark = Color(0xFF1A0E0A);
  static const Color coffeeDeep = Color(0xFF2C1810);
  static const Color coffeeMedium = Color(0xFF4A2C1A);
  static const Color coffeeWarm = Color(0xFF6B3A2A);
  static const Color coffeeGoldLight = Color(0xFFD4A843);
  static const Color leafGreenLight = Color(0xFF4CAF50);
  static const Color forestGreen = Color(0xFF1B4D1E);
  static const Color berryRed = Color(0xFFC62828);
  static const Color berryOrange = Color(0xFFE65100);

  // 🟢 Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryGreen,
      tertiary: goldCoffee,
      surface: lightBeige,
      onSurface: darkCoffee,
      inversePrimary: coffeeDeep,
    ),
    scaffoldBackgroundColor: lightBeige,
    cardColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkCoffee, letterSpacing: 2),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkCoffee),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkCoffee),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: darkCoffee),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: darkCoffee),
      ),
    ),
  );

  // 🆕 Tema oscuro (Café)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: coffeeMedium,
      secondary: coffeeWarm,
      tertiary: coffeeGoldLight,
      surface: coffeeDark,
      onSurface: white,
      inversePrimary: coffeeGoldLight,
    ),
    scaffoldBackgroundColor: coffeeDark,
    cardColor: coffeeDeep,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: white, letterSpacing: 2),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: white),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white60),
      ),
    ),
  );
}