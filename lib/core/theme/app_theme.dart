import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlack = Color(0xFF0F0E0C);
  static const Color secondaryBlack = Color(0xFF1E1C1A);
  static Color accentGold = const Color(0xFFD4AF37);
  static Color brightGold = const Color(0xFFEBC658);

  static final List<Color> accentColors = [
    const Color(0xFF480082), // 0: Indigo
    const Color(0xFFD4AF37), // 1: Gold
    const Color(0xFF2ECC71), // 2: Emerald Green
    const Color(0xFF800020), // 3: Dark Burgundy
    const Color(0xFFF7F4EB), // 4: Cream
    const Color(0xFFFFFFFF), // 5: White
  ];

  static final List<Color> brightColors = [
    const Color(0xFF6A0DAD), // 0: Indigo Bright
    const Color(0xFFEBC658), // 1: Gold Bright
    const Color(0xFF58EB7D), // 2: Emerald Bright
    const Color(0xFF9E1A3C), // 3: Dark Burgundy Bright
    const Color(0xFFFFFDF8), // 4: Cream Bright
    const Color(0xFFFFFFFF), // 5: White Bright
  ];
  static const Color bgCream = Color(0xFFF7F4EB);
  static const Color darkBrown = Color(0xFF2C2520);
  static const Color cleanWhite = Color(0xFFFFFFFF);
  static const Color borderGray = Color(0xFFD0C9BC);
  static const Color textDark = Color(0xFF242220);
  static const Color textLight = Color(0xFFF7F4EB);
  static const Color textMuted = Color(0xFF8C8479);

  // Status Colors
  static const Color statusSuccess = Color(0xFF4CAF50);
  static const Color statusWarning = Color(0xFFFFA000);
  static const Color statusDanger = Color(0xFFD32F2F);

  // Light Theme (Clean Premium Look)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlack,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.light(
        primary: primaryBlack,
        secondary: darkBrown,
        tertiary: accentGold,
        background: bgCream,
        surface: cleanWhite,
        onPrimary: cleanWhite,
        onSecondary: cleanWhite,
        onBackground: textDark,
        onSurface: textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgCream,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlack),
        titleTextStyle: GoogleFonts.outfit(
          color: primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: primaryBlack,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.outfit(
          color: primaryBlack,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: primaryBlack,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.outfit(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: const CardThemeData(
        color: cleanWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: borderGray, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: cleanWhite,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlack,
          side: BorderSide(color: primaryBlack, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // Dark Theme (Luxury Night Look)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentGold,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.dark(
        primary: accentGold,
        secondary: bgCream,
        tertiary: accentGold,
        background: primaryBlack,
        surface: secondaryBlack,
        onPrimary: primaryBlack,
        onSecondary: primaryBlack,
        onBackground: textLight,
        onSurface: textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: accentGold),
        titleTextStyle: GoogleFonts.outfit(
          color: accentGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: accentGold,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.outfit(
          color: accentGold,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: textLight,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: textLight,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: textLight,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.outfit(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: const CardThemeData(
        color: secondaryBlack,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: darkBrown, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: primaryBlack,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentGold,
          side: BorderSide(color: accentGold, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
