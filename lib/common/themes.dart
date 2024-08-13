import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFE8E8E8),
        onPrimary: Colors.white,
        secondary: Colors.black,
        onSecondary: const Color(0xFFcfcfcf),
        error: Colors.red.shade500,
        onError: Colors.red.shade300,
        surface: Colors.white,
        onSurface: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      titleMedium: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      bodyLarge: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              color: Colors.black)),
      bodyMedium: GoogleFonts.dosis(
          textStyle: const TextStyle(fontSize: 20.0, color: Colors.black)),
      bodySmall: GoogleFonts.dosis(
          textStyle: const TextStyle(fontSize: 18.0, color: Colors.black)),
    ));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF1A1A1A),
        onPrimary: Colors.black,
        secondary: Colors.white,
        onSecondary: Color(0xFF222220),
        error: Colors.red.shade400,
        onError: Colors.black,
        surface: Colors.black,
        onSurface: Color(0xFF1A1A1A),),

    textTheme: TextTheme(
      titleLarge: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w500,
              color: Colors.white)),
      titleMedium: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
              color: Colors.white)),
      bodyLarge: GoogleFonts.dosis(
          textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              color: Colors.white)),
      bodyMedium: GoogleFonts.dosis(
          textStyle: const TextStyle(fontSize: 20.0, color: Colors.white)),
      bodySmall: GoogleFonts.dosis(
          textStyle: const TextStyle(fontSize: 18.0, color: Colors.white)),
    ),

  iconTheme: IconThemeData(
    color: Colors.white,
  ),


);
