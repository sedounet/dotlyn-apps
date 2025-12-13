import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFE36C2D);
  static const Color darkGrey = Color(0xFF2C2C2C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryOrange, brightness: Brightness.light),
    fontFamily: 'Manrope',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(backgroundColor: primaryOrange, foregroundColor: Colors.white),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryOrange, brightness: Brightness.dark),
    fontFamily: 'Manrope',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
    ),
  );
}
