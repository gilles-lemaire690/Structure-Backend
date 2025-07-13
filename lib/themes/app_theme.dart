import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF03A9F4); // Bleu électrique
  static const Color secondaryColor = Color(0xFF039BE5); // Bleu électrique plus foncé
  static const Color accentColor = Color(0xFF0288D1); // Bleu électrique encore plus foncé
  static const Color backgroundColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF212121);
  static const Color disabledColor = Color(0xFF90CAF9);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color successColor = Color(0xFF4CAF50);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: secondaryColor,
      primaryColorLight: accentColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          side: BorderSide(color: primaryColor),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }
}
