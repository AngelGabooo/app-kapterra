import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🟢 Paleta de colores ORIGINAL (MANTENIDA)
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF66BB6A);
  static const Color goldCoffee = Color(0xFFD4A017);
  static const Color lightBeige = Color(0xFFF8F5F0);
  static const Color darkCoffee = Color(0xFF3E2723);
  static const Color white = Color(0xFFFFFFFF);
  static const Color alertOrange = Color(0xFFF57C00);

  // 🆕 NUEVOS colores para el Splash / Dark Theme
  static const Color coffeeDark = Color(0xFF1A0E0A);      // Café muy oscuro
  static const Color coffeeDeep = Color(0xFF2C1810);      // Café profundo
  static const Color coffeeMedium = Color(0xFF4A2C1A);    // Café medio
  static const Color coffeeWarm = Color(0xFF6B3A2A);      // Café cálido
  static const Color coffeeGoldLight = Color(0xFFD4A843); // Dorado claro
  static const Color leafGreenLight = Color(0xFF4CAF50);  // Verde hoja claro
  static const Color forestGreen = Color(0xFF1B4D1E);     // Verde bosque
  static const Color berryRed = Color(0xFFC62828);        // Rojo cereza
  static const Color berryOrange = Color(0xFFE65100);     // Naranja café

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryGreen,
      tertiary: goldCoffee,
      surface: lightBeige,
      onSurface: darkCoffee,
    ),
    scaffoldBackgroundColor: lightBeige,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkCoffee, letterSpacing: 2),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkCoffee),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkCoffee),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: darkCoffee),
      ),
    ),
  );

  // 🆕 NUEVO: Tema oscuro automático basado en la paleta café
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: coffeeMedium,
      secondary: coffeeWarm,
      tertiary: coffeeGoldLight,
      surface: coffeeDark,
      onSurface: white,
    ),
    scaffoldBackgroundColor: coffeeDark,
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: white, letterSpacing: 2),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: white),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
      ),
    ),
  );
}