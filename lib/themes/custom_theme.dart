import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      fontFamily: 'OpenSans',
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
