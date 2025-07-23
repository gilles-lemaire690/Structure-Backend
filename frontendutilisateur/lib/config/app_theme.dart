// lib/config/app_theme.dart
import 'package:flutter/material.dart';

// Définition de nos couleurs principales
class AppColors {
  static const Color primaryBlue = Color(0xFF1976D2); // Un bleu standard et vibrant
  static const Color lightBlue = Color(0xFFBBDEFB); // Un bleu plus clair pour les accents
  static const Color accentBlue = Color(0xFF42A5F5); // Un bleu légèrement plus vif
  static const Color white = Colors.white;
  static const Color darkGrey = Color(0xFF333333); // Pour le texte sur fond clair
  static const Color lightGrey = Color(0xFFF5F5F5); // Pour les arrière-plans subtils
}

// Définition du thème de l'application
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue, // Utilise la palette de bleu de Material Design
  primaryColor: AppColors.primaryBlue,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: AppColors.accentBlue,
    backgroundColor: AppColors.lightGrey, // Fond général de l'application
    cardColor: AppColors.white,
    errorColor: Colors.red,
    brightness: Brightness.light,
  ).copyWith(secondary: AppColors.accentBlue), // Pour le FloatingActionButton etc.
  scaffoldBackgroundColor: AppColors.lightGrey, // Couleur de fond des Scaffold
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: AppColors.white, // Couleur du texte et des icônes de l'AppBar
    elevation: 4.0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
  ),
  cardTheme: CardThemeData( // Correction ici: Utilisation de CardThemeData
    color: AppColors.white,
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Coins arrondis pour les cartes
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.primaryBlue,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Coins arrondis pour les boutons
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue, // Couleur de fond du bouton
      foregroundColor: AppColors.white, // Couleur du texte du bouton
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      elevation: 3.0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue, // Couleur du texte du bouton
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.accentBlue, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColors.lightBlue.withOpacity(0.5), width: 1.0),
    ),
    hintStyle: TextStyle(color: AppColors.darkGrey.withOpacity(0.6)),
    labelStyle: const TextStyle(color: AppColors.darkGrey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    displayMedium: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    displaySmall: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    headlineLarge: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    headlineMedium: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    headlineSmall: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    titleLarge: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    titleMedium: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    titleSmall: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    bodyLarge: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    bodyMedium: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    bodySmall: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    labelLarge: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    labelMedium: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
    labelSmall: TextStyle(fontFamily: 'Inter', color: AppColors.darkGrey),
  ),
);
