import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 22, 48, 141),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.kanitTextTheme(ThemeData.light().textTheme),
  );

  // 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 67, 198, 71),
      brightness: Brightness.dark,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.amber, // ตอนคลิก
      unselectedItemColor: Colors.white, // ยังไม่เลือก 
    ),

    textTheme: GoogleFonts.kanitTextTheme(
      ThemeData.dark().textTheme.apply(
        bodyColor: const Color.fromARGB(255, 255, 254, 254),
        displayColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    ),
  );
}
