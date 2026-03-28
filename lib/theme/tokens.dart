// lib/theme/tokens.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kCanvas = Color(0xFFFAFAFF);
const Color kLavender = Color(0xFFC8B3FD);
const Color kNavy = Color(0xFF273469);
const Color kCoral = Color(0xFFEE6C4D);
const Color kDark = Color(0xFF293241);
const Color kError = Color(0xFFEF4444);
const Color kSuccess = Color(0xFF22C55E);
const Color kWarning = Color(0xFFF59E0B);
const Color kInputHintColor = Color(0xFFB0B8D0);
const double kElevation = 0;

final LinearGradient kBgGradient = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: <double>[0.0, 0.38, 1.0],
  colors: <Color>[Color(0xFF6B7FD4), kNavy, kDark],
);

final BorderRadius kInputRadius = BorderRadius.circular(30);
final BorderRadius kCardRadius = BorderRadius.circular(16);
final BorderRadius kButtonRadius = BorderRadius.circular(30);
final Color kInputBg = Colors.white.withValues(alpha: 0.92);
final Color kGlassSurface = kCanvas.withValues(alpha: 0.12);

class PlanoraTheme {
  const PlanoraTheme._();

  static ThemeData build() {
    final TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: kDark,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: kLavender,
        onPrimary: kDark,
        secondary: kCoral,
        onSecondary: kCanvas,
        error: kError,
        onError: kCanvas,
        surface: kCanvas,
        onSurface: kDark,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kLavender,
          foregroundColor: kDark,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
          elevation: kElevation,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kInputBg,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: kInputHintColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: kInputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: kInputRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: kInputRadius,
          borderSide: const BorderSide(color: kLavender, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: kInputRadius,
          borderSide: const BorderSide(color: kError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: kInputRadius,
          borderSide: const BorderSide(color: kError),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kDark,
        selectedItemColor: kLavender,
        unselectedItemColor: Colors.white.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
