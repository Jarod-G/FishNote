import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      fontFamily: 'BungeeInline',
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.orange.shade200), // Fond de page orange légèrement sombre
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange.shade200, // Couleur de fond de l'AppBar
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white, // Couleur de fond du FloatingActionButton
      ),
    );
  }
}
