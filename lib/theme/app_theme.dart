import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF001F3F); // Azul marino
  static const Color accentColor = Color(0xFFFFC107); // Amarillo contraste
  static const Color backgroundColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
  );
}
