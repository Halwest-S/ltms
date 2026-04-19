import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Colors ── (Admin uses rose accent)
  static const Color ink        = Color(0xFF12131A);
  static const Color ink2       = Color(0xFF2D2F3D);
  static const Color surface    = Color(0xFFF5F4F0);
  static const Color card       = Color(0xFFFFFFFF);
  static const Color border     = Color(0xFFE8E6E0);
  static const Color muted      = Color(0xFF9A9AA8);
  static const Color rose       = Color(0xFFE11D48);
  static const Color roseLight  = Color(0xFFFFF1F2);
  static const Color teal       = Color(0xFF00B896);
  static const Color tealLight  = Color(0xFFE6F9F4);
  static const Color amber      = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color red        = Color(0xFFEF4444);
  static const Color redLight   = Color(0xFFFEE2E2);
  static const Color blue       = Color(0xFF3B82F6);
  static const Color blueLight  = Color(0xFFEFF6FF);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: surface,
    primaryColor: rose,
    colorScheme: ColorScheme.light(primary: rose, secondary: ink, surface: card, error: red),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.instrumentSerif(fontSize: 36, fontStyle: FontStyle.italic, color: ink),
      displayMedium: GoogleFonts.instrumentSerif(fontSize: 28, fontStyle: FontStyle.italic, color: ink),
      displaySmall: GoogleFonts.instrumentSerif(fontSize: 22, fontStyle: FontStyle.italic, color: ink),
      headlineLarge: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: ink),
      headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: ink),
      titleLarge: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800, color: ink),
      titleMedium: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: ink),
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: ink),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w400, color: ink2),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: muted),
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.06, color: muted),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: card, elevation: 0, centerTitle: false,
      iconTheme: const IconThemeData(color: ink),
      titleTextStyle: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800, color: ink),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: ink, foregroundColor: Colors.white,
      minimumSize: const Size(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
      elevation: 0,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: ink, minimumSize: const Size(0, 44),
      side: const BorderSide(color: border, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: card,
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: rose, width: 1.5)),
    ),
    cardTheme: CardThemeData(color: card, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: border)), margin: EdgeInsets.zero),
    dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
  );
}
