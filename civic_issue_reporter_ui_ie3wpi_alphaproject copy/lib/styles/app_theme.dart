import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Material 3 color palette
  static const Color primaryColor = Color(0xFF2E7D9A);
  static const Color primaryDark = Color(0xFF1A5C73);
  static const Color primaryLight = Color(0xFFB8E1F0);
  static const Color secondaryColor = Color(0xFF00A896);
  static const Color secondaryLight = Color(0xFF80E6D7);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color accentLight = Color(0xFFFFB3B3);
  static const Color successColor = Color(0xFF4ECDC4);
  static const Color warningColor = Color(0xFFFFE66D);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color infoColor = Color(0xFF4DABF7);

  // Neutral colors with better contrast
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color neutral200 = Color(0xFFF8FAFC);
  static const Color neutral300 = Color(0xFFE2E8F0);
  static const Color neutral400 = Color(0xFFCBD5E1);
  static const Color neutral500 = Color(0xFF94A3B8);
  static const Color neutral600 = Color(0xFF64748B);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // Surface colors for Material 3
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: neutral100,
        surfaceVariant: surfaceVariant,
        onSurface: neutral800,
        onSurfaceVariant: onSurfaceVariant,
        error: errorColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: neutral800,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: neutral800,
          ),
          displaySmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: neutral800,
          ),
          headlineLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: neutral800,
          ),
          headlineMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: neutral800,
          ),
          headlineSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: neutral800,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: neutral800,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: neutral800,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: neutral600,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: neutral800,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: neutral600,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: neutral600,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: neutral100,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: neutral100,
          elevation: 3,
          shadowColor: accentColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: neutral100,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: neutral600,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          color: neutral500,
        ),
      ),
      cardTheme: CardThemeData(
        color: neutral100,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: neutral100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(16),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: neutral100,
        selectedItemColor: primaryColor,
        unselectedItemColor: neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: neutral300,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Animation curves and durations for smooth transitions
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve fastAnimationCurve = Curves.easeOut;
  static const Curve slowAnimationCurve = Curves.easeInOutCubic;
}
