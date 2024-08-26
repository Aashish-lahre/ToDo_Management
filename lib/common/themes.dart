import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme baseTextTheme = TextTheme(

  titleLarge: GoogleFonts.inter(
      textStyle: const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  )),
  titleMedium: GoogleFonts.inter(
      textStyle: const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
  )),
  titleSmall: GoogleFonts.inter(
      textStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w200,
        overflow: TextOverflow.ellipsis,
      )),
  bodyLarge: GoogleFonts.inter(
      textStyle: const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
  )),
  bodyMedium: GoogleFonts.inter(
      textStyle: const TextStyle(
    fontSize: 16.0,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
  )),
  bodySmall: GoogleFonts.inter(
      textStyle: const TextStyle(
    fontSize: 14.0,
        fontWeight: FontWeight.w300,
        overflow: TextOverflow.ellipsis,
  )),
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,

  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFe9ecef),
    primary: Color(0xffcdcfd3),
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  textTheme: baseTextTheme.copyWith(
    titleLarge: baseTextTheme.titleLarge!.copyWith(color: Colors.black),
    titleMedium: baseTextTheme.titleMedium!.copyWith(color: Colors.black),
    titleSmall: baseTextTheme.titleSmall!.copyWith(color: Colors.black),
    bodyLarge: baseTextTheme.bodyLarge!.copyWith(color: Colors.black),
    bodyMedium: baseTextTheme.bodyMedium!.copyWith(color: Colors.black),
    bodySmall: baseTextTheme.bodySmall!.copyWith(color: Colors.grey.shade900),
  ),
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF202225),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF202225),


  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFF2f3136),
    // primary: Color(0xFF202225),
    primary: Color(0xFF292b2f),
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF202225),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: baseTextTheme.copyWith(
    titleLarge: baseTextTheme.titleLarge!.copyWith(color: Colors.white),
    titleMedium: baseTextTheme.titleMedium!.copyWith(color: Colors.white),
    titleSmall: baseTextTheme.titleSmall!.copyWith(color: Colors.white),
    bodyLarge: baseTextTheme.bodyLarge!.copyWith(color: Colors.white),
    bodyMedium: baseTextTheme.bodyMedium!.copyWith(color: Colors.white),
    bodySmall: baseTextTheme.bodySmall!.copyWith(color: Colors.white),
  ),
);
