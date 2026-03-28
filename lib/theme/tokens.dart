// lib/theme/tokens.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kCanvas = Color(0xFFFAFAFF);
const Color kMoon = Color(0xFFF4F0FF);
const Color kLavender = Color(0xFFC8B3FD);
const Color kLavenderBright = Color(0xFFDCC9FF);
const Color kNavy = Color(0xFF273469);
const Color kCoral = Color(0xFFEE6C4D);
const Color kDark = Color(0xFF293241);
const Color kInk = Color(0xFF20284A);
const Color kCardSurface = Color(0xFFFDFBFF);
const Color kCardSurfaceSoft = Color(0xFFF4EEFF);
const Color kCardText = Color(0xFF1F2742);
const Color kCardSubtext = Color(0xFF68748C);
const Color kCardBorder = Color(0xFFE7E0F5);
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
final BorderRadius kCardRadius = BorderRadius.circular(24);
final BorderRadius kButtonRadius = BorderRadius.circular(30);
final Color kInputBg = Colors.white.withValues(alpha: 0.92);
final Color kGlassSurface = kCardSurface;
final Color kGlassSurfaceStrong = kCardSurfaceSoft;
final Color kGlassStroke = kCardBorder;
final Color kMutedText = Colors.white.withValues(alpha: 0.72);

class PlanoraTheme {
  const PlanoraTheme._();

  static ThemeData build() {
    final TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 0.92,
      ),
      titleLarge: GoogleFonts.cormorantGaramond(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 0.98,
      ),
      titleMedium: GoogleFonts.workSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.workSans(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: kDark,
        letterSpacing: 0.2,
      ),
      labelMedium: GoogleFonts.workSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.8,
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
      iconTheme: const IconThemeData(color: Colors.white),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kLavenderBright,
          foregroundColor: kInk,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: kButtonRadius),
          elevation: kElevation,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kInputBg,
        hintStyle: GoogleFonts.workSans(fontSize: 14, color: kInputHintColor),
        labelStyle: GoogleFonts.workSans(fontSize: 14, color: kCardSubtext),
        prefixIconColor: kCardSubtext,
        suffixIconColor: kCardSubtext,
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
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        side: WidgetStateBorderSide.resolveWith(
          (Set<WidgetState> states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? kLavenderBright
                : Colors.white.withValues(alpha: 0.28),
            width: 1.25,
          ),
        ),
        fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return kLavenderBright;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll<Color>(kInk),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kLavenderBright,
          textStyle: textTheme.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        disabledColor: Colors.white.withValues(alpha: 0.08),
        selectedColor: kLavenderBright,
        secondarySelectedColor: kLavenderBright,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        labelStyle: textTheme.bodyMedium ?? const TextStyle(),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: kInk),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kDark,
        selectedItemColor: kLavender,
        unselectedItemColor: Colors.white.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kLavenderBright,
      ),
    );
  }
}
