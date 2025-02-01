import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5),
    secondaryHeaderColor: const Color(0xFF64B5F6),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1E88E5),
      secondary: const Color(0xFF64B5F6),
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: Colors.red[700]!,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF1565C0),
    secondaryHeaderColor: const Color(0xFF42A5F5),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF1565C0),
      secondary: const Color(0xFF42A5F5),
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: Colors.red[700]!,
    ),
  );

  static final ThemeData sepia = ThemeData(
    primaryColor: const Color(0xFF8B4513),
    secondaryHeaderColor: const Color(0xFFD2691E),
    scaffoldBackgroundColor: const Color(0xFFF4ECD8),
    textTheme: GoogleFonts.loraTextTheme().apply(
      bodyColor: const Color(0xFF4A4A4A),
      displayColor: const Color(0xFF4A4A4A),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF8B4513),
      secondary: const Color(0xFFD2691E),
      surface: const Color(0xFFF4ECD8),
      background: const Color(0xFFFDF5E6),
      error: Colors.red[700]!,
    ),
  );

  static final ThemeData nature = ThemeData(
    primaryColor: const Color(0xFF2E7D32),
    secondaryHeaderColor: const Color(0xFF81C784),
    scaffoldBackgroundColor: const Color(0xFFF1F8E9),
    textTheme: GoogleFonts.quicksandTextTheme(),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF2E7D32),
      secondary: const Color(0xFF81C784),
      surface: const Color(0xFFF1F8E9),
      background: const Color(0xFFE8F5E9),
      error: Colors.red[700]!,
    ),
  );
}
