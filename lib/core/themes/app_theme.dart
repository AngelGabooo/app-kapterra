import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🟢 Paleta de colores ORIGINAL (modo claro)
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

  // ============================================================
  // 🌫️ NEUMORFISMO — colores base de "piel" y sombras duales
  // ============================================================

  /// Color de fondo neumórfico (la "piel" sobre la que flotan los botones).
  static Color neuBase(bool isDark) =>
      isDark ? coffeeDark : lightBeige;

  /// Sombra clara (luz), esquina superior-izquierda.
  /// ⚠️ EN MODO OSCURO: sin brillo
  static Color neuLightShadow(bool isDark) =>
      isDark ? Colors.transparent : white.withOpacity(0.9);

  /// Sombra oscura, esquina inferior-derecha.
  /// ⚠️ EN MODO OSCURO: sin brillo
  static Color neuDarkShadow(bool isDark) =>
      isDark ? Colors.transparent : darkCoffee.withOpacity(0.12);

  /// Sombras "elevadas" (botón en reposo, flotando).
  /// ⚠️ EN MODO OSCURO: sin sombras
  static List<BoxShadow> neuRaised(bool isDark, {double intensity = 1}) {
    if (isDark) {
      // ✅ MODO OSCURO - SIN SOMBRAS
      return const [];
    }
    return [
      BoxShadow(
        color: neuDarkShadow(isDark),
        offset: Offset(6 * intensity, 6 * intensity),
        blurRadius: 14 * intensity,
      ),
      BoxShadow(
        color: neuLightShadow(isDark),
        offset: Offset(-6 * intensity, -6 * intensity),
        blurRadius: 14 * intensity,
      ),
    ];
  }

  /// Sombras "presionadas" (más pequeñas y cercanas → sensación de hundido).
  /// ⚠️ EN MODO OSCURO: sin sombras
  static List<BoxShadow> neuPressed(bool isDark) {
    if (isDark) {
      // ✅ MODO OSCURO - SIN SOMBRAS
      return const [];
    }
    return [
      BoxShadow(
        color: neuDarkShadow(isDark),
        offset: const Offset(2, 2),
        blurRadius: 5,
      ),
      BoxShadow(
        color: neuLightShadow(isDark),
        offset: const Offset(-2, -2),
        blurRadius: 5,
      ),
    ];
  }

  /// Gradiente sutil de relleno para dar volumen (efecto "soft UI").
  static LinearGradient neuFillGradient(bool isDark) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? [coffeeDeep, coffeeDark]
        : [white, lightBeige],
  );

  // ============================================================
  // 🌌 AURORA UI — blobs de color difuminados para el fondo espacial
  // ============================================================

  /// Colores de los "blobs" de aurora. Claro = verde/dorado café.
  /// Oscuro = degradados café con acentos dorados (según lo pedido).
  static List<Color> auroraColors(bool isDark) => isDark
      ? [
    coffeeWarm.withOpacity(0.20),  // ⬅️ Reducido el brillo
    coffeeGoldLight.withOpacity(0.10),
    forestGreen.withOpacity(0.12),
  ]
      : [
    primaryGreen.withOpacity(0.14),
    goldCoffee.withOpacity(0.16),
    secondaryGreen.withOpacity(0.12),
  ];

  // ============================================================
  // 🧊 LIQUID GLASS — cristal esmerilado translúcido
  // ============================================================

  /// Color base del "vidrio" (antes de aplicar blur).
  static Color glassTint(bool isDark) => isDark
      ? coffeeDeep.withOpacity(0.45)  // ⬅️ Más opaco en modo oscuro
      : Colors.white.withOpacity(0.72);

  /// Borde de vidrio: línea superior más clara, resto tenue (efecto biselado).
  static LinearGradient glassBorderGradient(bool isDark) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDark
        ? [Colors.white.withOpacity(0.08), Colors.transparent]  // ⬅️ Menos brillo
        : [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.3)],
  );

  /// Sombra suave y difusa "flotante" — da la sensación de profundidad espacial.
  /// ⚠️ EN MODO OSCURO: sin sombras
  static List<BoxShadow> floatingShadow(bool isDark) {
    if (isDark) {
      // ✅ MODO OSCURO - SIN SOMBRAS
      return const [];
    }
    return [
      BoxShadow(
        color: darkCoffee.withOpacity(0.16),
        blurRadius: 30,
        offset: const Offset(0, 16),
        spreadRadius: -6,
      ),
    ];
  }

  // ============================================================
  // 🧱 CLAYMORPHISM — volumen "de plastilina", pastel y suave
  // ============================================================

  /// Relleno diagonal claro→oscuro del mismo tono de acento (look "3D suave").
  static LinearGradient clayFill(bool isDark, Color accent) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? [
      Color.lerp(accent, Colors.black, 0.35)!,
      Color.lerp(accent, Colors.black, 0.65)!,
    ]
        : [
      Color.lerp(accent, Colors.white, 0.55)!,
      Color.lerp(accent, Colors.white, 0.15)!,
    ],
  );

  /// Doble sombra clay: una oscura abajo (profundidad) y un brillo arriba (relieve).
  /// ⚠️ EN MODO OSCURO: sin sombras
  static List<BoxShadow> claySoftShadow(bool isDark, {Color? accent}) {
    if (isDark) {
      // ✅ MODO OSCURO - SIN SOMBRAS
      return const [];
    }
    return [
      BoxShadow(
        color: (accent ?? darkCoffee).withOpacity(0.18),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.7),
        blurRadius: 12,
        offset: const Offset(-4, -6),
      ),
    ];
  }

  /// Versión más intensa de un color, usada para brillos ("glow") detrás de iconos.
  /// ⚠️ EN MODO OSCURO: sin brillo
  static Color glow(Color base, {bool isDark = false}) {
    if (isDark) {
      // ✅ MODO OSCURO - SIN BRILLO
      return Colors.transparent;
    }
    return base.withOpacity(0.35);
  }

  // ============================================================
  // 🎨 THEMES
  // ============================================================

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